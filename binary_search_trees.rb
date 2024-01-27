require 'pry-byebug'
tree_array = [1, 7, 4, 23, 8, 9, 4, 7, 5, 2, 9, 67, 6345, 324]

class Tree
  attr_accessor :array, :root

  def initialize(array)
    @array = array.uniq.sort
    @root = nil
  end

  def build_tree(array, start = 0, final = array.length - 1)
    return nil if start > final || array == nil || array.empty? # Base case
    mid = ((start+final) / 2.0).ceil
    root = Node.new(array[mid])
    root.left = build_tree(array[0..mid - 1], 0, mid - 1)
    root.right = build_tree(array[mid + 1..array.length - 1], 0, mid - 2) if array.length.even?
    root.right = build_tree(array[mid + 1..array.length - 1], 0, mid - 1) if array.length.odd?  
    @root = root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value)
    return @root = Node.new(value) if @root == nil
    tmp = @root
    until tmp.data == nil do
      if value <= tmp.data
        return tmp.left = Node.new(value) if tmp.left == nil || tmp.left.data == nil
        tmp = tmp.left
      elsif value > tmp.data
        return tmp.right = Node.new(value) if tmp.right == nil || tmp.right.data == nil
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
      level_order_arr.append(tmp) if tmp.data != nil
      yield (level_order_arr[-1].data) if tmp.data != nil
      queue.append(tmp.left) if tmp.left != nil
      queue.append(tmp.right) if tmp.right != nil
      tmp = queue.shift
      end
    else
      @array
    end
  end

  def inorder(tmp = @root, &block)
    if block_given?
      inorder(tmp.left, &block) if tmp.left != nil
      yield tmp.data if tmp.data != nil
      inorder(tmp.right, &block) if tmp.right != nil
    else
      p @array
    end
  end

  def preorder(tmp = @root, &block)
     if block_given?
       yield tmp.data if tmp.data != nil
       preorder(tmp.left, &block) if tmp.left != nil
       preorder(tmp.right, &block) if tmp.right != nil
     else
       p @array
     end
   end

   def postorder(tmp = @root, &block)
     if block_given?
       postorder(tmp.left, &block) if tmp.left != nil
       postorder(tmp.right, &block) if tmp.right != nil
       yield tmp.data if tmp.data != nil
     else
       p @array
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

  def height(node)
    current_height = 0
    tmp = find(node)
    tmp = [tmp, 0]
    return nil if tmp[0] == nil
    level_order_arr = []
    queue = []
    until queue.empty? && tmp == nil
      level_order_arr.append([tmp[0], tmp[1]]) if tmp[0].data != nil
      queue.append([tmp[0].left, tmp[1] + 1]) if tmp[0].left != nil
      queue.append([tmp[0].right, tmp[1] + 1]) if tmp[0].right != nil
      tmp = queue.shift
    end
    level_order_arr[-1][1]
  end

  def depth(node)
    current_depth = 0
    return nil if find(node) == nil
    tmp = [@root, 0]
    level_order_arr = []
    queue = []
    until tmp[0].data == node
      level_order_arr.append([tmp[0], tmp[1]]) if tmp[0].data != nil
      queue.append([tmp[0].left, tmp[1] + 1]) if tmp[0].left.data != nil
      queue.append([tmp[0].right, tmp[1] + 1]) if tmp[0].right.data != nil
      tmp = queue.shift
    end
    tmp[1]
  end

  def balanced?
    left_height = 0
    right_height = 0
    left_height = height(@root.left.data) if @root.left != nil
    right_height = height(@root.right.data) if @root.right != nil
    if left_height > right_height + 1 || right_height > left_height + 1
      false
    else
      true
    end
  end

  def rebalance
    arr = []
    postorder {|value| arr.append(value)}
    build_tree(arr.sort.uniq)
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
binary_search_tree.build_tree(Array.new(15) {rand(1..100)}.uniq.sort)
p binary_search_tree.balanced?
binary_search_tree.preorder {|value| print "#{value}, "} 
print "\n"
binary_search_tree.postorder {|value| print "#{value}, "}
print "\n"
binary_search_tree.inorder { |value| print "#{value}, "}
print "\n"
binary_search_tree.insert(500)
binary_search_tree.insert(600)
binary_search_tree.insert(700)
p binary_search_tree.balanced?
binary_search_tree.rebalance
p binary_search_tree.balanced?
binary_search_tree.preorder {|value| print "#{value}, "}
print "\n"
binary_search_tree.postorder {|value| print "#{value}, "}
print "\n"
binary_search_tree.inorder { |value| print "#{value}, "}









