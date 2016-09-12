require "set"

class Node
  attr_accessor :name, :adjacents

  def initialize(name)
    # I'm using a Set instead of an Array to
    # avoid duplications. We don't want node1
    # connected to node2 twice.
    @adjacents = Set.new
    @name = name
  end

  def to_s
    @name
  end
end

class Graph
  attr_accessor :nodes

  def initialize
    @nodes = []
  end

  def add_edge(from, to)
    from.adjacents << to
  end
end

# Topological sort works only for DAGs (Directed acyclic graphs).
# The objective of this sort is do redraw the DAG so all edged
# point upwards.
class TopologicalSort
  attr_accessor :post_order

  def initialize(graph)
    @post_order = []
    @visited = []

    graph.nodes.each do |node|
      dfs(node) unless @visited.include?(node)
    end
  end

  private
  def dfs(node)
    @visited << node
    node.adjacents.each do |adj_node|
      dfs(adj_node) unless @visited.include?(adj_node)
    end

    @post_order << node
  end
end

graph = Graph.new

graph.nodes << (node1 = Node.new("Node #1"))
graph.nodes << (node2 = Node.new("Node #2"))
graph.nodes << (node3 = Node.new("Node #3"))
graph.nodes << (node4 = Node.new("Node #4"))
graph.nodes << (node5 = Node.new("Node #5"))


graph.add_edge(node1, node2)
graph.add_edge(node1, node5)
graph.add_edge(node2, node3)
graph.add_edge(node2, node4)

p TopologicalSort.new(graph).post_order.map(&:to_s)
# "Node #3", "Node #4", "Node #2", "Node #5", "Node #1"

