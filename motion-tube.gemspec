# -*- encoding: utf-8 -*-
VERSION = "0.0.2"

Gem::Specification.new do |spec|
  spec.name          = "motion-tube"
  spec.version       = VERSION
  spec.authors       = ["David Ruan"]
  spec.email         = ["ruanwz@gmail.com"]
  spec.description   = %q{Get youtube video info}
  spec.summary       = %q{Get youtube video info}
  spec.homepage      = ""
  spec.license       = ""

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "motion-cocoapods", ">= 1.4.1"
  spec.add_dependency "motion-require", ">= 0.1"
  spec.add_dependency "afmotion"
  spec.add_dependency "sugarcube"

  spec.add_development_dependency "rake"
end
