# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'pp'
class Edge
    attr_accessor :node1, :node2, :weight

    def initialize(node1, node2, weight)
        @node1 = node1
        @node2 = node2
        @weight = weight
    end

    def <=>(other)
        weight <=> other.weight
    end

    def to_s
        "#{node1.to_s} <=> #{node2.to_s} with weight #{weight}"
    end
end

class Graph
    attr_accessor :nodes
    attr_accessor :edges

    def initialize
        @nodes = []
        @edges = []
    end

    def add_node(node)
        nodes << node
        node.graph = self
    end

    def add_edge(from, to, weight)
        edges << Edge.new(from, to, weight)
    end
end

class Node
    attr_accessor :name, :graph, :types

    def initialize(name)
        @name = name
        @types = []
    end

    def adjacents
        graph.edges.select { |e| e.from == self }.map(&:to)
    end

    def to_s
        @name
    end
end

class UnionFind
    def initialize(nodes)
        @unions = {}
        nodes.each_with_index do |node, index|
            @unions[node] = index
        end
    end

    def connected?(node1, node2)
        @unions[node1] == @unions[node2]
    end

    def union(node1, node2)
        return if connected?(node1, node2)
        node1_id = @unions[node1]
        node2_id = @unions[node2]

        @unions.each do |node, id|
            @unions[node] = node1_id if id == node2_id
        end
    end
end

class Kruskal
  def compute_mst(graph)
    mst = []
    edges = graph.edges.sort!

    union_find = UnionFind.new(graph.nodes)
    while edges.any? && mst.size <= graph.nodes.size
      edge = edges.shift
      if !union_find.connected?(edge.node1, edge.node2)
        union_find.union(edge.node1, edge.node2)
        mst << edge
      end
    end

    mst
  end
end


N, M, K = gets.strip.split(' ').map(&:to_i)
i = 1
graph = Graph.new
hash = Hash.new
while i <= N
    node = Node.new(i)
    array = gets.strip.split(' ')
    types = array.shift.to_i
    while !array.empty?
        node.types.push(array.shift)
    end
    graph.add_node(node)
    hash[i] = node
    i += 1
end
i = 1
while i <= M
    from, to, weight = gets.strip.split(' ').map(&:to_i)
    graph.add_edge(hash[from], hash[to], weight)
    i += 1
end

pp Kruskal.new.compute_mst(graph).map(&:to_s)
