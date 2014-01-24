require_relative 'obj'
require_relative 'point'

module ObjParser
  class ObjParser
    
    VERTEX_LINE_ID = 'v'
    NORMAL_LINE_ID = 'vn'
    TEXTURE_LINE_ID = 'vt'
    INDEXES_ID = 'f'
    
    attr_accessor :index_array_starting_at_index
    
    def initialize(index_array_starting_at = 0)
      self.index_array_starting_at_index = 1
    end
    
    def load(input_io)
      obj = Obj.new
      input_io.rewind
      while(line = input_io.gets)
        parser_for_line(line).call(line, obj)
      end
      obj
    end
    
    private
  
    def parser_for_line(input_line)
      {
        NORMAL_LINE_ID => Proc.new {|line, obj| obj.normals <<  parse_point_on_line(line, :item_size => 3)},
        TEXTURE_LINE_ID => Proc.new {|line, obj| obj.textures << parse_point_on_line(line, :item_size => 2)},
        VERTEX_LINE_ID => Proc.new {|line, obj| obj.vertice << parse_point_on_line(line, :item_size => 3)},
        INDEXES_ID => Proc.new { |line, obj|
              v_regex = line.include?("/") ? /\s(\d+).*?\s(\d+).*?\s(\d+)/ : /\s*(\d+)\s*(\d+)\s*(\d+)/
                              obj.vertice_indexes += (line.scan(v_regex).last || []).map{|index| index.to_i - self.index_array_starting_at_index}
                    n_regex = line.include?("/") ? /\s\d*\/\d*\/(\d+)\s\d*\/\d*\/(\d+)\s\d*\/\d*\/(\d+)/ : /\s*(\d+)\s*(\d+)\s*(\d+)/
                              obj.normals_indexes += (line.scan(n_regex).last || []).map{|index| index.to_i - self.index_array_starting_at_index}
                    t_regex = line.include?("/") ? /\s\d*\/(\d+)\/\d*\s\d*\/(\d+)\/\d*\s\d*\/(\d+)\/\d*/ : /nothing/
                              obj.textures_indexes += (line.scan(t_regex).last || []).map{|index| index.to_i - self.index_array_starting_at_index} }
      }[input_line[0..1].rstrip] || Proc.new{|line, obj| [] }
    end
  
    def parse_point_on_line(line, options = {})
      item_size = {:item_size => 3}.merge(options)[:item_size] 
      vertice_regex = "\s(.[^\s]*)" * item_size
      Point.new((line.scan(/#{vertice_regex}/).last || []))
    end
  end
end