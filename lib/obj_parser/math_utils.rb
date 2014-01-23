require 'matrix'

module ObjLoader

  module MathUtils
      
    def self.tangent_for_vertices_and_texures(vertices, textures)
    	u1, u2, u3 = textures.map {|texture| texture[0]}
    	v1, v2, v3 = textures.map {|texture| texture[1]}
    	p1, p2, p3 = vertices.map {|vertex| normalized_vector(vertex)}
    	#Tangent formula: http://jerome.jouvie.free.fr/opengl-tutorials/Lesson8.php
    	nominator = substract_vectors( mul_vector_by_scalar(substract_vectors(p2, p1), (v3 - v1)), mul_vector_by_scalar(substract_vectors(p3, p1), (v2 - v1)))
    	denominator = (u2 - u1) * (v3 - v1) - (v2 - v1) * (u3 - u1)
    	denominator = denominator == 0 ? 1 : denominator
    	divide_vector_by_scalar(nominator, denominator)
    end
  
    def self.tangent2_for_vertices_and_texures(vertices, textures)
    	u1, u2, u3 = textures.map {|texture| texture[0]}
    	v1, v2, v3 = textures.map {|texture| texture[1]}
    	p1, p2, p3 = vertices.map {|vertex| normalized_vector(vertex)}
    	q1 = substract_vectors(p2, p1)
    	q2 = substract_vectors(p3, p2)
    	t1 = u2 - u1
    	t2 = u3 - u1
    	substract_vectors(mul_vector_by_scalar(q1, t2), mul_vector_by_scalar(q2, t1))
    end
  
    def self.binormal2_for_vertices_and_texures(vertices, textures)
    	u1, u2, u3 = textures.map {|texture| texture[0]}
    	v1, v2, v3 = textures.map {|texture| texture[1]}
    	p1, p2, p3 = vertices.map {|vertex| normalized_vector(vertex)}
    	q1 = substract_vectors(p2, p1)
    	q2 = substract_vectors(p3, p2)
    	s1 = v2 - v1
    	s2 = v3 - v1
    	binormal = sum_vectors(mul_vector_by_scalar(q1, -s2), mul_vector_by_scalar(q2, s1))
    end
    
    def self.cross_product(v1, v2)
      [ ( (v1[1] * v2[2]) - (v1[2] * v2[1]) ),
       - ( (v1[0] * v2[2]) - (v1[2] * v2[0]) ),
         ( (v1[0] * v2[1]) - (v1[1] * v2[0]) ) ]
    end
 
    def self.substract_vectors a, b
      [a[0] - b[0], a[1] - b[1], a[2] - b[2]]
    end
  
    def self.sum_vectors a, b
      [a[0] + b[0], a[1] + b[1], a[2] + b[2]]
    end
  
    def self.mul_vector_by_scalar(vector, scalar)
      vector.map {|component|  component * scalar}
    end
  
    def self.divide_vector_by_scalar(vector, scalar)
      vector.map {|component|  component / scalar}
    end
  
    def self.vector_length(vector)
      Math.sqrt(vector.map { |item| (item * item) }.reduce(:+))
    end
  
    def self.normalized_vector(vector)
    	current_vector_length = vector_length(vector)
    	current_vector_length = current_vector_length == 0 ? 1 : current_vector_length
    	vector.map do |component|
    		component / current_vector_length
    	end
    end
  
    def self.dot(vector1, vector2)
    	#http://en.wikipedia.org/wiki/Dot_product
    	vector1.each_with_index.map do |component, index|
    		component * vector2[index]
    	end.inject(&:+)
    end
  
    def self.orthogonalized_vector_with_vector(vector1, vector2)
    	#Gram-Schmidt orthogonalization -> http://jerome.jouvie.free.fr/opengl-tutorials/Lesson8.php
    	substract_vectors(vector1, mul_vector_by_scalar(vector2, dot(vector2, vector1)))
    end
		
    def self.mul_mat_per_vector(mat, vector)
    	m = Matrix[mat[0], mat[1], mat[2]]
    	v = Matrix[ [vector[0]], [vector[1]], [vector[2]]]
    	(m * v).to_a
    end
  
    def self.mat_inverse(mat)
    	m = Matrix[mat[0],mat[1], mat[2]]
    	puts "non regular" unless m.regular?
    	m.regular? ? m.inverse.to_a : m.to_a
    end
  
    def self.normal_for_face_with_vertices(face_vertices)
    	p1 = face_vertices[0]
    	p2 = face_vertices[1]
    	p3 = face_vertices[2]
    	u = substract_vectors(p2, p1)
    	v = substract_vectors(p3, p1)
    	cross_product(u, v)
    end
  end
end