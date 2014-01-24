# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'obj_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "obj_parser"
  spec.version       = ObjParser::VERSION
  spec.authors       = ["Laurent Cobos"]
  spec.email         = ["laurent@11factory.fr"]
  spec.summary       = %q{3D obj file parser.}
  spec.description   = %q{Parse a 3D obj file to a ruby data structure. Can compute tangent per vertex. Can merge vertice, normals, and textures indexes into a single index for OpenGL use case.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
