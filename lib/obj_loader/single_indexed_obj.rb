require 'delegate.rb'

module ObjLoader
  class SingleIndexedObj < SimpleDelegator

    attr_accessor :detailed_vertice
    attr_accessor :indexes
    
    def target; __getobj__ ;end
    def class; target.class ;end
    
    class << self
      def build_with_obj(obj)
        instance = self.new(obj)
        instance.setup
        instance
      end  
    end
    
    def setup
      compute_detailed_vertice
    	temp_vertice = []
    	temp_normals = []
    	temp_textures = []
    	temp_tangents = []
    	vec_indexes = []
    	self.vertice_indexes.each_with_index do |vertex_index, index|
    		vertex = self.detailed_vertice[vertex_index]
    		normal = vertex.normals.select{|n| n == self.normals[self.normals_indexes[index]] }.first
    		texture = vertex.textures.select{|n| n == self.textures[self.textures_indexes[index]] }.first
    		if(point_used_for_vertex_at_index?(normal, vertex_index) && point_used_for_vertex_at_index?(texture, vertex_index))
    			candids = texture.flag[vertex_index] & normal.flag[vertex_index]
    			vec_indexes << candids.first
    		else
    			temp_vertice << vertex
    			temp_tangents << vertex.tangent if vertex.tangent
    			vec_indexes << temp_vertice.count - 1
    			if(normal)
    				temp_normals << normal
    				normal.flag ||= {}
    				normal.flag[vertex_index] ||= []
    				normal.flag[vertex_index] << temp_vertice.count - 1
    			end
    			if(texture)
    				temp_textures << texture
    				texture.flag ||= {}
    				texture.flag[vertex_index] ||= []
    				texture.flag[vertex_index] << temp_vertice.count - 1
    			end
    		end
    	end
    	self.vertice = temp_vertice.map {|detailed_vertice| Point.new(detailed_vertice.data)}
    	self.normals = temp_normals.map {|detailed_vertice| Point.new(detailed_vertice.data)}
    	self.textures = temp_textures.map {|detailed_vertice| Point.new(detailed_vertice.data)}
    	self.tangents = temp_tangents.map {|detailed_vertice| Point.new(detailed_vertice.data)}
    	self.vertice_indexes = vec_indexes
    	self.normals_indexes = vec_indexes
    	self.textures_indexes = vec_indexes
    	self.tangents_indexes = vec_indexes
      self.indexes = vec_indexes
    end
    
    private

    def point_used_for_vertex_at_index?(point, vertex_index)
  	  point && point.flag && point.flag[vertex_index]
    end
        
    def compute_detailed_vertice
      self.detailed_vertice = self.vertice.map {|vertex| Point.new(vertex.data)}
    	self.vertice_indexes.each_with_index do |vertex_index, index|
    		vertex = self.detailed_vertice[vertex_index]
        [:normals, :textures, :tangents].each do |element|
      		if(self.send(element).any? && self.send("#{element}_indexes")[index])
      			candid = self.send(element)[self.send("#{element}_indexes")[index]] 
      			vertex.send(element) << candid unless vertex.send(element).include?(candid)
      		end
        end
    	end      
    end
    
  end
end