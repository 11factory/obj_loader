require_relative 'face'

module ObjLoader
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
        [:vertice, :normals, :textures].each do |element|
          point_indexes = (self.send("#{element}_indexes")[face_index * VERTEX_BY_FACE..-1] || []).take(self.send("#{element}_point_size"))
          points = point_indexes.map do |point_index|
            self.send(element)[point_index]
          end
          face.send("#{element}=", points)
        end
      end
    end
    
    private
    
    def vertice_point_size; 3 ;end
    def normals_point_size; 3 ;end
    def textures_point_size; 2 ;end
    
  end
end