require 'test_helper'

describe ObjParser::SingleIndexedObj do
  
  before do
    @obj = ObjParser::Obj.new
    @obj.vertice = [p([0.0,0.0,0.0]), p([0.0,0.0,1.0]), p([0.0,1.0,0.0]), p([0.0,1.0,1.0])]
    @obj.vertice_indexes = [0, 1, 2,  0, 2, 3]
    @obj.normals = [p([1.0,0.0,0.0]), p([0.0,1.0,0.0])]
    @obj.normals_indexes = [1, 0, 1,  1, 0, 0]
    @obj.textures = [p([1.0,0.0,0.0]), p([0.0,1.0,0.0])]
    @obj.textures_indexes = [1, 0, 1,  1, 0, 0]
    @obj.compute_tangents
    @single_indexed_obj = ObjParser::SingleIndexedObj.build_with_obj(@obj)
  end
  
  describe 'compute detailed vertice' do
    
    it 'can build detailed vertice with associated uniq normals, textures,..' do
      @single_indexed_obj.detailed_vertice[2].normals.map(&:data).must_equal([p([0.0,1.0,0.0]), p([1.0,0.0,0.0])].map(&:data))
    end
  
    it 'should skip duplicate normals, textures by vertex' do
      @single_indexed_obj.detailed_vertice[0].normals.count.must_equal(1)
    end
  
    it 'should not modify original vertice' do
      @obj.vertice.first.normals.must_be_empty
      @single_indexed_obj.vertice.first.normals.must_be_empty
    end
    
  end
  
  describe 'use a single index' do
    
    it 'reorganize normals, textures, ... based on vertices indexes' do
      @single_indexed_obj.normals.count.must_equal(@obj.vertice_indexes.uniq.count)
      @single_indexed_obj.normals.map(&:data).must_equal(
        [p([0.0,1.0,0.0]), p([1.0,0.0,0.0]), p([0.0,1.0,0.0]), p([1.0,0.0,0.0]), p([1.0,0.0,0.0])].map(&:data))
    end
    
  end
    
end