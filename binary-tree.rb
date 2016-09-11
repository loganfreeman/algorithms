class Tree
    attr_accessor :left
    attr_accessor :right
    attr_accessor :data

    def initialize(x = nil)
        @left = nil
        @right = nil
        @data = x
    end

    def insert(x)
        list = []
        if @data.nil?
            @data = x
        elsif @left.nil?
            @left = Tree.new(x)
        elsif @right.nil?
            @right = Tree.new(x)
        else
            list << @left
            list << @right
            loop do
                node = list.shift
                if node.left.nil?
                    node.insert(x)
                    break
                else
                    list << node.left
                end
                if node.right.nil?
                    node.insert(x)
                    break
                else
                    list << node.right
                end
            end
        end
    end

    def traverse
        list = []
        yield @data
        list << @left unless @left.nil?
        list << @right unless @right.nil?
        loop do
            break if list.empty?
            node = list.shift
            yield node.data
            list << node.left unless node.left.nil?
            list << node.right unless node.right.nil?
        end
    end

    def inorder
        @left.inorder { |y| yield y } unless @left.nil?
        yield @data
        @right.inorder { |y| yield y } unless @right.nil?
    end

    def preorder
        yield @data
        @left.preorder { |y| yield y } unless @left.nil?
        @right.preorder { |y| yield y } unless @right.nil?
    end

    def postorder
        @left.postorder { |y| yield y } unless @left.nil?
        @right.postorder { |y| yield y } unless @right.nil?
        yield @data
    end

    def search(x)
        if data == x
            return self
        else
            ltree = !left.nil? ? left.search(x) : nil
            return ltree unless ltree.nil?
            rtree = !right.nil? ? right.search(x) : nil
            return rtree unless rtree.nil?
        end
        nil
    end

    def to_s
        '[' +
            (left ? left.to_s + ',' : '') +
            data.inspect +
            (right ? ',' + right.to_s : '') + ']'
    end

    def to_a
        temp = []
        temp += left.to_a if left
        temp << data
        temp += right.to_a if right
        temp
    end

    def infix
        unless @left.nil?
            flag = %w(* / + -).include? @left.data
            yield '(' if flag
            @left.infix { |y| yield y }
            yield ')' if flag
        end
        yield @data
        unless @right.nil?
            flag = %w(* / + -).include? @right.data
            yield '(' if flag
            @right.infix { |y| yield y } unless @right.nil?
            yield ')' if flag
        end
    end
 end

items = [1, 2, 3, 4, 5, 6, 7]

tree = Tree.new

items.each { |x| tree.insert(x) }

tree.traverse { |x| print "#{x} " }
print "\n"

def addnode(nodes)
    node = nodes.shift
    tree = Tree.new node
    if %w(* / + -).include? node
        tree.left = addnode nodes
        tree.right = addnode nodes
    end
    tree
end

prefix = %w( * + 32 * 21 45 - 72 + 23 11 )

tree = addnode prefix

str = ''
tree.infix { |x| str += x }
# str is now "(32+(21*45))*(72-(23+11))"

# Prints "1 2 3 4 5 6 7 "
