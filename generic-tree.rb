# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'pp'
class LinkedList
    # By implementing LinkedList#each, we can include Enumerable
    include Enumerable

    attr_reader :head, :length

    def initialize
        @head = LinkedListNode.new(nil)
        @length = 0
    end

    # O(1) time
    def unshift(value)
        @head = @head.insert_before(value)
        @length += 1

        self
    end

    # O(1) time
    def shift
        result = @head.value
        @head = LinkedListNode(@head.next)
        @length = [length - 1, 0].max

        result
    end

    # O(1) time
    def empty?
        head.empty?
    end

    def each
        node = head

        until node.empty?
            yield(node.value)
            node = node.next
        end

        self
    end
end

# This allows us to call LinkedListNode(value) and is different
# than the class "LinkedListNode".  This is how Ruby methods
# like Integer(value), Array(value), String(value), etc.
# work.
def LinkedListNode(value)
    case value
    when LinkedListNode
        value
    else
        LinkedListNode.new(value)
    end
end

class LinkedListNode
    attr_accessor :value, :next

    def initialize(value = nil, next_node = nil)
        @value = value
        @next = next_node
    end

    # O(1) time
    # Insert +value+ after this LinkedListNode and return new LinkedListNode
    def insert_after(value)
        node = LinkedListNode(value)

        node.next = self.next if self.next
        self.next = node

        node
    end

    # O(1) time
    # Insert +value+ before this LinkedListNode and return new LinkedListNode
    def insert_before(value)
        node = LinkedListNode(value)

        node.next = self

        node
    end

    def empty?
        value.nil?
    end
end

def Tree(value)
    case value
    when Tree
        value
    else
        Tree.new(value)
    end
end

# Implement a generic tree class.  Each node
# is also a Tree and can have any number of children.
class Tree
    attr_reader :value, :children
    def initialize(value)
        @value = value
        @children = LinkedList.new
    end

    # Add a new child to this node
    # O(1) time
    def add_child(value)
        @children.unshift(Tree(value))
    end

    def each(&block)
    end
    
    def traverse
        list = []
        yield @value
        @children.each do |child|
            list.push(child)
        end
        
        loop do
            break if list.empty?
            node = list.shift
            yield node.value
            node.children.each do |child|
                list.push(child)
            end
        end
    end
    
    def depth_first_traveral(&block)
        yield @value
        @children.each do |child|
            child.depth_first_traveral(&block)
        end
    end
    
    
    def inOrder(&block)
    end
    
    def preOrder(&block)
    end
    
    def postOrder(&block)
        @children.each do |child|
            child.postOrder(&block)
        end
        yield @value
    end
end
N, M = gets.strip.split(' ').map(&:to_i)
i = 1
hash = {}
i = 1
while i <= N
    hash[i] = Tree.new(i)
    i += 1
end
i = 1
while i <= M
    from, to = gets.strip.split(' ').map(&:to_i).sort
    parent = hash[from]
    child = hash[to]
    parent.add_child(child)
    i += 1
end
hash[1].traverse do |node|
    puts node
end
puts "#########"
hash[1].depth_first_traveral do |node|
    puts node
end
