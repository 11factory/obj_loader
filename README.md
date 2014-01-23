# ObjParser

Parse a 3D obj file to a ruby data structure.
Can compute tangent per vertex.
Can merge vertice, normals, and textures indexes into a single index for OpenGL use case.

## Installation

Add this line to your application's Gemfile:

    gem 'obj_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install obj_parser

## Usage

Sample to parse an obj file, generate tangents and transform to a single indexed 3D model.

  @parser = ObjLoader::ObjParser.new
  obj = @parser.load(File.open("/Users/lcobos/development/ios/OpenGL-4/models/cube.obj"))
  obj.compute_tangents
  obj = ObjLoader::SingleIndexedObj.build_with_obj(obj)
  puts obj.vertice.map(&:data).join(",")
  puts obj.normals.map(&:data).join(",")
  puts obj.textures.map(&:data).join(",")
  puts obj.tangents.map(&:data).join(",")
  puts obj.indexes.join(",")
  

## Contributing

1. Fork it ( http://github.com/<my-github-username>/obj_parser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
