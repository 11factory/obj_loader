require 'test_helper'

describe ObjParser::Obj do
  
  before do
    @obj = ObjParser::Obj.new
    @obj.vertice = [p([0.0,0.0,0.0]), p([0.0,0.0,1.0]), p([0.0,1.0,0.0]), p([0.0,1.0,1.0])]
    @obj.vertice_indexes = [0, 1, 2, 1, 2, 3]
    @obj.normals = [p([1.0,0.0,0.0]), p([0.0,1.0,0.0])]
    @obj.normals_indexes = [0, 0, 0, 1, 1, 1]
    @obj.textures = [p([1.0,0.0]), p([0.0,1.0])]
    @obj.textures_indexes = [1, 1, 0, 0, 1, 1]
  end
  
  it 'resolve faces based on indexes' do
    @obj.resolve_faces
    @obj.faces.count.must_equal(2)
    @obj.faces.first.vertice.map(&:data).must_equal([p([0.0,0.0,0.0]), p([0.0,0.0,1.0]), p([0.0,1.0,0.0])].map(&:data))
    @obj.faces.first.normals.map(&:data).must_equal([p([1.0,0.0,0.0]), p([1.0,0.0,0.0]), p([1.0,0.0,0.0])].map(&:data))
    @obj.faces.first.textures.map(&:data).must_equal([p([0.0,1.0]), p([0.0,1.0]), p([1.0,0.0])].map(&:data))
  end
  
  it 'compute tangents' do
    @obj.compute_tangents
    puts @obj.tangents.map(&:data)
    result = @obj.faces.each_with_index.map do |face, index| 
  		face.vertice.map do |vertex|
  		  ("%.2f" % ObjParser::MathUtils::dot(vertex.tangent.data[0..2], vertex.normal.data)).to_f
  		end.reduce(&:+)
    end.reduce(&:+)
    result.must_equal(0)
  end
  
end