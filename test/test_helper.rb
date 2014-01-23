require 'minitest'
require 'minitest/autorun'
require 'obj_loader'

def p(data)
  ObjLoader::Point.new(data)
end
