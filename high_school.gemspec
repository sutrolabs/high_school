# frozen_string_literal: true

require_relative "lib/high_school/version"

Gem::Specification.new do |spec|
  spec.name = "high_school"
  spec.version = HighSchool::VERSION
  spec.authors = ["n8"]
  spec.email = ["n8@getcensus.com"]

  spec.summary = "A Redis based Mutex"
  spec.description = "Use Redis to establish a lock."
  spec.homepage = "https://github.com/sutrolabs/high_school"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.require_paths = ["lib"]
end
