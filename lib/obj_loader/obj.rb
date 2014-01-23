module ObjLoader
  class Obj
    attr_accessor :normals, :normals_indexes
    attr_accessor :vertice, :vertice_indexes
    attr_accessor :textures, :textures_indexes
    attr_accessor :tangents, :tangents_indexes
    attr_accessor :current_primitives
    
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
  end
end