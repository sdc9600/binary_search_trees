require 'pry-byebug'
tree_array = [1, 7, 4, 23, 8, 9, 4, 7, 5, 2, 9, 67, 6345, 324]

class Tree
  attr_accessor :array, :root

  def initialize(array)
    @array = array.uniq.sort
    @root = nil
  end

  def build_tree(array, start = 0, final = array.length - 1)
    #binding.pry
    return nil if start > final # Base case
    mid = ((start+final) / 2.0).ceil
    root = Node.new(array[mid])
    root.left = build_tree(array[0..mid - 1], 0, mid - 1)
    root.right = build_tree(array[mid + 1..array.length - 1], 0, mid - 1)
    
    @root = root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end



class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

binary_search_tree = Tree.new(tree_array)


binary_search_tree.build_tree(binary_search_tree.array)
p binary_search_tree.pretty_print
p binary_search_tree.root
