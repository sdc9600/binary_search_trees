require 'pry-byebug'
tree_array = [1, 7, 4, 23, 8, 9, 4, 7, 5, 2, 9, 67, 6345, 324]

class Tree
  attr_accessor :array, :root

  def initialize(array)
    @array = array.uniq.sort
    @root = nil
  end

  def build_tree(array, start = 0, final = array.length - 1)
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

  def insert(value)
    return @root = value if @root == nil
    tmp = @root
    until tmp == nil do
      if value <= tmp.data
        return tmp.left = Node.new(value) if tmp.left.data == nil 
        tmp = tmp.left
      elsif value > tmp.data
        return tmp.right = Node.new(value) if tmp.right.data == nil
        tmp = tmp.right
      end
    end
  end

  def inorder_successor(successor)
  tmp = successor.left #Finding the maximal value of the left-subtree of the root node.
    until tmp.right == nil
      if tmp.right.data == nil
        successor.data = tmp.data
        successor.left = tmp.left
        return successor
      elsif tmp.right.right.data == nil
        successor.data = tmp.right.data
        tmp.right = nil
        return successor
      end
      tmp = tmp.right
    end
  end

  def delete(value)
    tmp = @root
    until tmp == nil do
      return tmp.left = nil if tmp.left.data == value && tmp.left.left == nil && tmp.left.right == nil
      return tmp.right = nil if tmp.right.data == value && tmp.right.left == nil && tmp.right.right == nil
      return tmp.left = tmp.left.left if tmp.left.data == value && (tmp.left.left.data != nil && tmp.left.right.data == nil)
      return tmp.left = tmp.left.right if tmp.left.data == value && (tmp.left.left.data == nil && tmp.left.right.data != nil) 
      return tmp.right = tmp.right.left if tmp.right.data == value && (tmp.right.left.data != nil && tmp.right.right.data == nil)
      return tmp.right = tmp.right.right if tmp.right.data == value && (tmp.right.left.data == nil && tmp.right.right.data != nil)
        if value == tmp.data && tmp.right != nil && tmp.left != nil
          return inorder_successor(tmp)
        elsif value < tmp.data
          tmp = tmp.left
        elsif value > tmp.data
          tmp = tmp.right
        end
      end
      nil
  end

  def level_order
    tmp = @root
    level_order_arr = []
    queue = []
    if block_given?
      until queue.empty? && level_order_arr != []
      level_order_arr.append(tmp)
      queue.append(tmp.left) if tmp.left != nil
      queue.append(tmp.right) if tmp.right != nil
      yield tmp
      tmp = queue.shift
      end
    else
      "no block"
    end
  end

  def find(value)
    tmp = @root
    until tmp == nil do
      if value < tmp.data
        tmp = tmp.left
      elsif value > tmp.data
        tmp = tmp.right
      elsif value = tmp.data
        return tmp
      end
    end
    nil
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
binary_search_tree.delete(8)
binary_search_tree.pretty_print
p binary_search_tree.level_order {}


