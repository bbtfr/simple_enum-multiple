require 'spec_helper'

describe SimpleEnum::Multiple::Accessors::MultipleAccessor, active_record: true do
  shared_examples_for 'multiple accessor' do |accessor, source|
    fake_active_record(:klass) do
      serialize :text_cds, Array
      as_enum :favorites, %w{iphone ipad macbook},
        accessor: accessor, source: source, with: []
    end

    context 'generate_enum_class_accessors_for' do
      context '.favorites_accessor' do
        subject { klass.favorites_accessor }

        it 'returns a SimpleEnum::Accessor' do
          expect(subject).to be_a(described_class)
        end
      end
    end

    context 'generate_enum_instance_accessors_for' do
      subject { klass.new(source => [1]) }

      context '#favorites' do
        it 'delegates to accessor' do
          expect(subject.favorites).to eq [:ipad]
        end
      end

      context '#favorites=' do
        it 'delegates to accessor' do
          subject.favorites = [:iphone]
          expect(subject.favorites).to eq [:iphone]
        end
      end

      context '#favorites?' do
        it 'delegates to accessor' do
          expect(subject.favorites?).to be_truthy
        end
      end
    end

    context 'generate_enum_dirty_methods_for' do
      subject { klass.new }

      it 'does not respond to #favorites_changed?' do
        expect(subject).to_not respond_to(:favorites_changed?)
      end

      it 'does not responds to #favorites_was' do
        expect(subject).to_not respond_to(:favorites_was)
      end

      context 'with: :dirty' do
        fake_active_record(:klass) do
          serialize :text_cds, Array
          as_enum :favorites, %w{iphone ipad macbook},
            accessor: accessor, source: source, with: [:dirty]
        end

        subject { klass.new(source => [1]) }

        it 'delegates #favorites_changed? to accessor' do
          expect(subject.favorites_changed?).to be_truthy
        end

        it 'delegates #favorites_was to accessor' do
          expect(subject.favorites_was).to eq []
          subject.save
          expect(subject.favorites_was).to eq [:ipad]
          subject.destroy
        end
      end
    end

    context 'generate_enum_attribute_methods_for' do
      subject { klass.new }

      it 'does not respond to #male? or #female?' do
        expect(subject).to_not respond_to(:iphone?)
        expect(subject).to_not respond_to(:ipad?)
      end

      it 'does not respond to #male! or #female!' do
        expect(subject).to_not respond_to(:iphone!)
        expect(subject).to_not respond_to(:ipad!)
      end

      context 'with: :attribute' do
        fake_active_record(:klass) do
          serialize :text_cds, Array
          as_enum :favorites, %w{iphone ipad macbook},
            accessor: accessor, source: source, with: [:attribute]
        end

        subject { klass.new }

        it 'delegates #favorites? to accessor' do
          expect(subject.favorites?).to be_falsey
          subject.favorites = [:ipad]
          expect(subject.favorites?).to be_truthy
        end

        it 'delegates #ipad? to accessor' do
          subject.favorites = [:ipad]
          expect(subject.ipad?).to be_truthy
        end

        it 'delegates #iphone? to accessor' do
          subject.favorites = [:ipad]
          expect(subject.iphone?).to be_falsey
        end

        it 'delegates #ipad! to accessor' do
          expect(subject.ipad!).to eq ["ipad"]
        end

        it 'delegates #iphone! to accessor' do
          subject.favorites = [:ipad]
          expect(subject.iphone!).to eq ["iphone"]
        end
      end

      context 'with a prefix' do
        fake_active_record(:klass) do
          serialize :text_cds, Array
          as_enum :favorites, %w{iphone ipad macbook},
            accessor: accessor, source: source, with: [:attribute], prefix: true
        end

        subject { klass.new }

        it 'delegates #favorites? to accessor' do
          expect(subject.favorites?).to be_falsey
          subject.favorites = [:ipad]
          expect(subject.favorites?).to be_truthy
        end

        it 'delegates #favorites_ipad? to accessor' do
          subject.favorites = [:ipad]
          expect(subject.favorites_ipad?).to be_truthy
        end

        it 'delegates #favorites_iphone? to accessor' do
          subject.favorites = [:ipad]
          expect(subject.favorites_iphone?).to be_falsey
        end

        it 'delegates #favorites_ipad! to accessor' do
          expect(subject.favorites_ipad!).to eq ["ipad"]
        end

        it 'delegates #favorites_iphone! to accessor' do
          subject.favorites = [:ipad]
          expect(subject.favorites_iphone!).to eq ["iphone"]
        end
      end
    end

    context 'generate_enum_scope_methods_for', active_record: true do
      subject { klass }

      it 'does not add .males nor .females' do
        expect(subject).to_not respond_to(:iphones)
        expect(subject).to_not respond_to(:ipads)
      end

      context 'with: :attribute' do
        fake_active_record(:klass) do
          serialize :text_cds, Array
          as_enum :favorites, %w{iphone ipad macbook},
            accessor: accessor, source: source, with: [:scope]
        end

        context '.iphones' do
          subject { klass.iphones }
          it_behaves_like 'delegates to accessor#scope', :iphone
        end

        context '.ipads' do
          subject { klass.ipads }
          it_behaves_like 'delegates to accessor#scope', :ipad
        end

        context 'with prefix' do
          fake_active_record(:klass) do
            serialize :text_cds, Array
            as_enum :favorites, %w{iphone ipad macbook},
              accessor: accessor, source: source, with: [:scope], prefix: true
          end

          context '.favorites_iphones' do
            subject { klass.favorites_iphones }
            it_behaves_like 'delegates to accessor#scope', :iphone
          end

          context '.favorites_ipads' do
            subject { klass.favorites_ipads }
            it_behaves_like 'delegates to accessor#scope', :ipad
          end
        end
      end
    end
  end

  context 'accessor: :multiple' do
    shared_examples_for 'delegates to accessor#scope' do |value|
      it 'delegates to #scope' do
        expect{subject}.to raise_error(NoMethodError)
      end
    end

    it_behaves_like 'multiple accessor', :multiple, :text_cds
  end

  context 'accessor: :bitwise' do
    shared_examples_for 'delegates to accessor#scope' do |value|
      it 'delegates to #scope' do
        subject.count == klass.all.select{|r|r.favorites.include? value}.size
      end
    end

    it_behaves_like 'multiple accessor', :bitwise, :bitwise_cds
  end

  context 'accessor: :join_table' do
    shared_examples_for 'delegates to accessor#scope' do |value|
      it 'delegates to #scope' do
        subject.count == klass.all.select{|r|r.favorites.include? value}.size
      end
    end

    it_behaves_like 'multiple accessor', :join_table, :favorite_cds
  end
end
