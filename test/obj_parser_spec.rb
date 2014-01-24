require 'test_helper'
require 'stringio'

describe ObjParser::ObjParser do
  
  it "should get obj vertice, normals, textures and indexes" do
    @parser = ObjParser::ObjParser.new
    obj = @parser.load(StringIO.new(sample_cube_obj))
    obj.vertice.take(3).map(&:data).must_equal([p([0.0,0.0,0.0]), p([0.0,0.0,1.0]), p([0.0,1.0,0.0])].map(&:data))
    obj.normals.count.must_equal(6)
    obj.textures.count.must_equal(4)
    obj.vertice_indexes.count.must_equal(36)
    obj.normals_indexes.count.must_equal(36)
    obj.textures_indexes.count.must_equal(36)
  end

  private
    
  def sample_cube_obj
    <<CUBE_OBJ
# Blender v2.65 (sub 0) OBJ File: ''
# www.blender.org
o Cube
v 0.0 0.0 0.0
v 0.0 0.0 1.0
v 0.0 1.0 0.0
v 0.0 1.0 1.0
v 1.0 0.0 0.0
v 1.0 0.0 1.0
v 1.0 1.0 0.0
v 1.0 1.0 1.0

vn 0.0 0.0 1.0
vn 0.0 0.0 -1.0
vn 0.0 1.0 0.0
vn 0.0 -1.0 0.0
vn 1.0 0.0 0.0
vn -1.0 0.0 0.0

vt 0.0 0.0
vt 1.0 0.0
vt 1.0 1.0
vt 0.0 1.0

f 1/1/2 7/3/2 5/2/2
f 1/1/2 3/4/2 7/3/2 
f 1/1/6 4/3/6 3/4/6 
f 1/1/6 2/2/6 4/3/6 
f 3/1/3 8/3/3 7/4/3 
f 3/1/3 4/2/3 8/3/3 
f 5/2/5 7/3/5 8/4/5 
f 5/2/5 8/4/5 6/1/5 
f 1/1/4 5/2/4 6/3/4 
f 1/1/4 6/3/4 2/4/4 
f 2/1/1 6/2/1 8/3/1 
f 2/1/1 8/3/1 4/4/1
CUBE_OBJ
  end
end