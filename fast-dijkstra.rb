class Node
  attr_accessor :name, :graph

  def initialize(name)
    @name = name
  end

  def adjacent_edges
    graph.edges.select{|e| e.from == self}
  end

  def to_s
    @name
  end
end

class Edge
  attr_accessor :from, :to, :weight

  def initialize(from, to, weight)
    @from, @to, @weight = from, to, weight
  end

  def <=>(other)
    self.weight <=> other.weight
  end

  def to_s
    "#{from.to_s} => #{to.to_s} with weight #{weight}"
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

# A very simple priority key implementation to help our Dijkstra algorithm.
class PriorityQueue
  def initialize
    @queue = {}
  end

  def any?
    @queue.any?
  end

  def insert(key, value)
    @queue[key] = value
    order_queue
  end

  def remove_min
    @queue.shift.first
  end

  private
  def order_queue
    @queue.sort_by {|_key, value| value }
  end
end


class Dijkstra
  def initialize(graph, source_node)
    @graph = graph
    @source_node = source_node
    @path_to = {}
    @distance_to = {}
    @pq = PriorityQueue.new

    compute_shortest_path
  end

  def shortest_path_to(node)
    path = []
    while node != @source_node
      path.unshift(node)
      node = @path_to[node]
    end

    path.unshift(@source_node)
  end

  private
  # This method will compute the shortest path from the source node to all the
  # other nodes in the graph.
  def compute_shortest_path
    update_distance_of_all_edges_to(Float::INFINITY)
    @distance_to[@source_node] = 0

    # The prioriy queue holds a node and its distance from the source node.
    @pq.insert(@source_node, 0)
    while @pq.any?
      node = @pq.remove_min
      node.adjacent_edges.each do |adj_edge|
        relax(adj_edge)
      end
    end
  end

  def update_distance_of_all_edges_to(distance)
    @graph.nodes.each do |node|
      @distance_to[node] = distance
    end
  end

  # Edge relaxation basically means that we are checking if the shortest known
  # path to a given node is still valid (i.e. we didn't find an even
  # shorter path).
  def relax(edge)
    return if @distance_to[edge.to] <= @distance_to[edge.from] + edge.weight

    @distance_to[edge.to] = @distance_to[edge.from] + edge.weight
    @path_to[edge.to] = edge.from

    # If the node is already in this priority queue, the only that happens is
    # that its distance is decreased.
    @pq.insert(edge.to, @distance_to[edge.to])
  end
end


graph = Graph.new

graph.add_node(node0 = Node.new("Node #0"))
graph.add_node(node1 = Node.new("Node #1"))
graph.add_node(node2 = Node.new("Node #2"))
graph.add_node(node3 = Node.new("Node #3"))
graph.add_node(node4 = Node.new("Node #4"))
graph.add_node(node5 = Node.new("Node #5"))
graph.add_node(node6 = Node.new("Node #6"))
graph.add_node(node7 = Node.new("Node #7"))

graph.add_edge(node0, node1, 5)
graph.add_edge(node0, node4, 9)
graph.add_edge(node0, node7, 8)
graph.add_edge(node1, node2, 12)
graph.add_edge(node1, node3, 15)
graph.add_edge(node1, node7, 4)
graph.add_edge(node2, node3, 3)
graph.add_edge(node2, node6, 11)
graph.add_edge(node3, node6, 9)
graph.add_edge(node4, node5, 4)
graph.add_edge(node4, node6, 20)
graph.add_edge(node4, node7, 5)
graph.add_edge(node5, node2, 1)
graph.add_edge(node5, node6, 13)
graph.add_edge(node7, node5, 6)
graph.add_edge(node7, node2, 7)

shortest_path = Dijkstra.new(graph, node0).shortest_path_to(node3)
pp shortest_path.map(&:to_s)
