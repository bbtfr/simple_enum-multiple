# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_enum/multiple/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_enum-multiple"
  spec.version       = SimpleEnum::Multiple::VERSION
  spec.authors       = ["Theo Li"]
  spec.email         = ["bbtfrr@gmail.com"]

  spec.summary       = %q{Multi-select enum support for SimpleEnum.}
  spec.description   = %q{SimpleEnum::Multiple is extension of SimpleEnum, which brings multi-select enum support to SimpleEnum.}
  spec.homepage      = "https://github.com/bbtfr/simple_enum-multiple"
  spec.license       = "MIT"

  spec.required_ruby_version     = ">= 1.9.3"
  spec.required_rubygems_version = ">= 2.0.0"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'simple_enum', '~> 2.2'

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'activerecord', '>= 4.0.0'
  spec.add_development_dependency 'mongoid', '>= 4.0.0'
  spec.add_development_dependency 'rspec', '~> 2.14'
end
