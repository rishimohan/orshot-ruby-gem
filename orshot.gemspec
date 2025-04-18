# frozen_string_literal: true

require_relative 'lib/orshot/version'

Gem::Specification.new do |spec|
  spec.name = 'orshot'
  spec.version = Orshot::VERSION
  spec.authors = ['rishimohan']
  spec.email = ['iamrishi.ms@gmail.com']

  spec.summary = 'Orshot API sdk for ruby'
  spec.description = 'Orshot API sdk for ruby'
  spec.homepage = 'https://orshot.com'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/rishimohan/orshot-ruby-gem'
  spec.metadata['changelog_uri'] = 'https://github.com/rishimohan/orshot-ruby-gem'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_dependency 'httparty', '~> 0.21.0'
end
