require 'simple_enum/multiple/accessors/multiple_accessor'

module SimpleEnum
  module Multiple
    module Accessors
      class JoinTableAccessor < MultipleAccessor
        attr_accessor :table, :foreign_key, :remote_key

        def init(klass)
          klass_table_name = klass.table_name.to_s
          join_table_name = [klass_table_name, name.pluralize].sort.join("_").to_sym
          table = self.table = Arel::Table.new(join_table_name)

          source = self.source
          name = self.name

          foreign_key = self.foreign_key = klass_table_name.singularize.foreign_key
          remote_key = self.remote_key = name.singularize.foreign_key

          connection = ActiveRecord::Base.connection

          klass.class_eval do
            attr_accessor source

            define_method :"#{source}_changed?" do
              instance_variable_get(:"@#{source}") !=
                instance_variable_get(:"@#{source}_was")
            end

            define_method :"#{source}_was" do
              instance_variable = instance_variable_get(:"@#{source}_was")
              return instance_variable if instance_variable
              sql = table.where(table[foreign_key].eq(self.id))
                .project(table[remote_key])
                .to_sql
              original_cds = connection.send(:select, sql).rows.map(&:first).map(&:to_i)
              instance_variable_set(:"@#{source}_was", original_cds)
            end

            define_method source do
              instance_variable = instance_variable_get(:"@#{source}")
              return instance_variable if instance_variable
              instance_variable_set(:"@#{source}", send(:"#{source}_was").dup)
            end

            define_method :"update_#{source}!" do
              return unless send(:"#{source}_changed?")
              original_cds = send(:"#{source}_was")
              current_cds = send(source).select(&:present?)

              # if any enum been removed
              if (original_cds - current_cds).any?
                delete_sql = table.where(table[foreign_key].eq(self.id))
                  .where(table[remote_key].in(original_cds - current_cds))
                  .compile_delete
                  .to_sql
                connection.send(:delete, delete_sql)
              end

              # if any enum been added
              if (current_cds - original_cds).any?
                insert_sql = table.create_insert.tap do |insert_manager|
                  insert_manager.into table
                  insert_manager.columns << table[foreign_key]
                  insert_manager.columns << table[remote_key]

                  values = (current_cds - original_cds).map do |id|
                    "(#{self.id}, #{id})"
                  end.join(", ")
                  insert_manager.values = Arel::Nodes::SqlLiteral.new("VALUES #{values}")
                end.to_sql
                connection.send(:insert, insert_sql)
              end

              instance_variable_set(:"@#{source}_was", current_cds)
            end

            define_method :"clear_#{source}!" do
              delete_sql = table.where(table[foreign_key].eq(self.id))
                .compile_delete
                .to_sql
              connection.send(:delete, delete_sql)
            end

            after_save :"update_#{source}!"
            after_destroy :"clear_#{source}!"
          end
        end

        def was(object)
          fetch_keys(object.send(:"#{source}_was").to_a)
        end

        def changed?(object)
          object.send(:"#{source}_changed?")
        end

        def scope(collection, value)
          join = Arel::Nodes::Group.new(table).to_sql
          on = collection.arel_table[collection.primary_key].eq(table[foreign_key]).to_sql
          collection.joins("INNER JOIN #{join} ON #{on}")
            .where(table[foreign_key].eq(value))
        end
      end
    end
  end
end
