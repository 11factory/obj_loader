require 'test_helper'

describe ObjLoader::Obj do
  
  it 'should resolve faces based on indexes' do
    obj = ObjLoader::Obj.new
    obj.vertice = [p([0.0,0.0,0.0]), p([0.0,0.0,1.0]), p([0.0,1.0,0.0]), p([0.0,1.0,1.0])]
    obj.vertice_indexes = [0, 1, 2, 1, 2, 3]
    obj.normals = [p([1.0,0.0,0.0])]
    obj.normals_indexes = [0, 0]
    obj.resolve_faces
    obj.faces.count.must_equal(2)
    obj.faces.first.vertice.map(&:data).must_equal([p([0.0,0.0,0.0]), p([0.0,0.0,1.0]), p([0.0,1.0,0.0])].map(&:data))
    obj.faces.first.normals.map(&:data).must_equal([p([1.0,0.0,0.0]), p([1.0,0.0,0.0])].map(&:data))
  end
  
end