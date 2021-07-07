
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "setka_integration/version"

Gem::Specification.new do |spec|
  spec.name          = "setka_integration"
  spec.version       = SetkaIntegration::VERSION
  spec.authors       = ["Mikhail Zadera"]
  spec.email         = ["m_zadera@setka.io"]

  spec.summary       = "Wrapper for Setka Editor Custom integration API V2"
  spec.description   = %q{Wraps the SetkaIntegration API for access from ruby applications}
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "~> 6.0"

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
