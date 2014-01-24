require_relative 'face'
require_relative 'math_utils'

module ObjParser
  class Obj
    VERTEX_BY_FACE = 3
    attr_accessor :normals, :normals_indexes
    attr_accessor :vertice, :vertice_indexes
    attr_accessor :textures, :textures_indexes
    attr_accessor :tangents, :tangents_indexes
    attr_accessor :faces
    
    def initialize
      self.vertice = []
      self.normals = []
      self.textures = []
      self.tangents = []
      self.vertice_indexes = []
      self.normals_indexes = []
      self.textures_indexes = []
      self.tangents_indexes = []
    end
    
    def resolve_faces
      self.faces = (self.vertice_indexes.count / VERTEX_BY_FACE).times.map { Face.new }
      self.faces.each_with_index do |face, face_index|
        [:vertice, :normals, :textures, :tangents].each do |element|
          point_indexes = (self.send("#{element}_indexes")[face_index * VERTEX_BY_FACE..-1] || []).take(VERTEX_BY_FACE)
          points = point_indexes.map do |point_index|
            self.send(element)[point_index]
          end
          face.send("#{element}=", points)
        end
      end
    end
    
    def compute_tangents
      self.resolve_faces
    	self.tangents = []
    	self.tangents_indexes = []
    	pindex = 0
    	self.faces.each do |face|
      	pindex += 1
    		tangent_for_face = ObjParser::MathUtils::tangent_for_vertices_and_texures(face.vertice.map(&:data), face.textures.map(&:data))
    		tangent_for_face = ObjParser::MathUtils::normalized_vector(tangent_for_face)
    		#set the same tangent for the 3 vertex of current face
    		#re-compute tangents for duplicates vertices to get tangent per face
    		face.vertice.each_with_index do |vertex, index|
    			vertex.tangent.data = ObjParser::MathUtils::sum_vectors(vertex.tangent.data, tangent_for_face)
    		end
      end
	
    	#orthonormalize
    	self.faces.each_with_index do |face,pindex|
    	  face.vertice.each_with_index do |vertex, index|
    		vertex.tangent.data = ObjParser::MathUtils::orthogonalized_vector_with_vector(vertex.tangent.data, self.normals[self.normals_indexes[pindex * 3 + index]].data)
    		vertex.tangent.data = ObjParser::MathUtils::normalized_vector(vertex.tangent.data)
       	 end
    	end
	
    	#binormal should be computed with per vertex tangent and summed for each vertex
    	self.faces.each_with_index do |face,pindex|
    		face.vertice.each_with_index do |vertex, index|
    			binormal = ObjParser::MathUtils::cross_product(self.normals[self.normals_indexes[pindex * 3 + index]].data, vertex.tangent.data)
    			vertex.binormal.data = ObjParser::MathUtils::sum_vectors(vertex.binormal.data, binormal)
    		end
    	end
	
    	self.faces.each_with_index do |face,pindex|
    	  face.vertice.each_with_index do |vertex, index|
      		vertex.binormal.data = ObjParser::MathUtils::normalized_vector(vertex.binormal.data)
      		if(ObjParser::MathUtils::dot(ObjParser::MathUtils::cross_product(self.normals[self.normals_indexes[pindex * 3 + index]].data, vertex.tangent.data), vertex.binormal.data) < 0.0)
      			vertex.tangent.data[3] = -1.0 
      		else
      			vertex.tangent.data[3] = 1.0 
      		end
        end
      end

    	self.faces.each_with_index do |face, index|
    		self.tangents += face.vertice.map(&:tangent)
    		point_index = index * 3
    		self.tangents_indexes += [point_index, point_index + 1, point_index + 2]
    	end
    end
  
    def tangents_self_check
      self.resolve_faces
      result = self.faces.each_with_index.map do |face, index| 
    		face.vertice.map do |vertex|
    		  ("%.2f" % ObjParser::MathUtils::dot(vertex.tangent.data[0..2], vertex.normal.data)).to_f
    		end.reduce(&:+)
      end.reduce(&:+)
      puts "RESULT: tangents and normals are orthogonal -> [#{result == 0 ? "VALID" : "NOT VALID"}]"
      result == 0
    end
        
  end
end