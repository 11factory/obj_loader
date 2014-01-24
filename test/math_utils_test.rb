require 'test/unit'
require 'obj_parser'

class ObjParser::MathUtilsTest < Test::Unit::TestCase
  
  def test_tangent_computing_given_vertices_and_normal
  	vertices = [[0,0,0], [1,0,0], [1,1,0]]
  	textures = [[0,1], [1,1], [1,0]]
  	assert_equal [1,0,0], ObjParser::MathUtils.tangent_for_vertices_and_texures(vertices, textures)
  end
  
  def test_tangent2_and_binormal_computing_given_vertices_and_normal
  	vertices = [[0,0,0], [1,0,0], [1,1,0]]
  	textures = [[0,1], [1,1], [1,0]]
  	normal = [0,0,-1]
  	assert_array_in_delta [1.29289321881345, -0.707106781186547, 0.0], ObjParser::MathUtils.tangent2_for_vertices_and_texures(vertices, textures), 0.00001
  end
  
  def test_vector_length
  	assert_equal 0, ObjParser::MathUtils::vector_length([0,0,0])
  	assert_equal 1, ObjParser::MathUtils::vector_length([1,0,0])
  	assert_equal Math.sqrt(29), ObjParser::MathUtils.vector_length([2,3,4])
  end
  
  def test_vector_normalization
  	assert_equal [0,0,0], ObjParser::MathUtils.normalized_vector([0,0,0])
  	assert_equal [1,0,0], ObjParser::MathUtils.normalized_vector([1,0,0])
  	assert_array_in_delta [0.371390676354104, 0.557086014531156, 0.742781352708207], ObjParser::MathUtils.normalized_vector([2,3,4]), 0.00001
  end
  
  def test_dot_product
  	v1 = [1,0,0]
  	v2 = [0,1,0]
  	assert_equal 0, ObjParser::MathUtils.dot(v1, v2)
  	v2 = [1,1,0]
  	assert_equal 1, ObjParser::MathUtils.dot(v1, v2)
  end
  
  def test_orthogonalize
  	v1 = [0.2,1,0]
  	v2 = [1,0,0]
  	assert_equal [0,1,0], ObjParser::MathUtils.orthogonalized_vector_with_vector(v1, v2)
  end
  
  def test_normal_computing_given_face_vertices
  	vertices = [[0,0,0], [1,0,0], [1,1,0]]
  	assert_equal [0,0,1].map(&:to_s), ObjParser::MathUtils.normal_for_face_with_vertices(vertices).map(&:to_s)
  	vertices = [[0,0,0], [0,0,1], [0,1,0]]
  	assert_equal [-1,0,0].map(&:to_s), ObjParser::MathUtils.normal_for_face_with_vertices(vertices).map(&:to_s)
  end
  
  private
  
  def assert_array_in_delta(expected_array, actual_array, delta)
    assert_equal(expected_array.count, actual_array.count)
    expected_array.each_with_index do |expected_element, index|
      assert_in_delta(expected_element, actual_array[index], delta)
    end
  end
end