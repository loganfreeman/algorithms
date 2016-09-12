class Node
  attr_accessor :name, :graph

  def initialize(name)
    @name = name
  end

  def adjacents
    graph.edges.select{|e| e.from == self}.map(&:to)
  end

  def to_s
    @name
  end
end

class Edge
  attr_accessor :from, :to

  def initialize(from, to)
    @from, @to = from, to
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

  def add_edge(from, to)
    edges << Edge.new(from, to)
  end

  def reverse!
    edges.each do |e|
      e.from, e.to = e.to, e.from
    end
  end
end

class DepthFirstOrder
  attr_accessor :reverse_post_order, :visited

  def initialize(graph)
    @graph = graph
    @reverse_post_order = []
    @visited = []

    graph.nodes.each do |node|
      dfs(node) unless @visited.include?(node)
    end
    p @reverse_post_order.map(&:to_s)
  end

  private
  def dfs(node)
    @visited << node
    node.adjacents.each do |adj_node|
      dfs(adj_node) unless @visited.include?(adj_node)
    end

    @reverse_post_order << node
  end
end

# Step 1: Run depth first in the reverse graph
# Step 2: Run depth first search again, considering the vertices
#         in the order given by the first dfs
class StrongComponents
  attr_accessor :strong_components

  def initialize(graph)
    @graph = graph
    @visited = []
    @strong_components = {}
    counter = 0

    graph.reverse!
    nodes = DepthFirstOrder.new(graph).reverse_post_order
    nodes.each do |node|
      next if @visited.include?(node)

      dfs(node, counter)
      counter += 1
    end
  end

  private
  def dfs(node, counter)
    @visited << node
    @strong_components[counter] ||= []
    @strong_components[counter] << node

    node.adjacents.each do |adj_node|
      dfs(adj_node, counter) unless @visited.include?(adj_node)
    end
  end
end
