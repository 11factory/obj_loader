module ObjLoader
  class Point
    attr_accessor :data
    attr_accessor :current_tangent
    attr_accessor :current_binormal
    attr_accessor :current_normal
  
    attr_accessor :normals
    attr_accessor :textures
    attr_accessor :flag
  
    def initialize(point_data = [0, 0, 0])
      self.data = point_data.map(&:to_f)
      self.textures = []
      self.normals = []
    end
  
    def tangent
      self.current_tangent ||= Point.new
    end
   
    def binormal
      self.current_binormal ||= Point.new
    end
  
    def normal
      self.current_normal ||= Point.new
    end
     
    def x; self.data[0]; end
    def y; self.data[1]; end
    def z; self.data[2]; end
  
    def u; self.data[0]; end
    def v; self.data[1]; end
  end
end