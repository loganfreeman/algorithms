require 'set'

class Node
    attr_accessor :name, :adjacents, :value, :total

    def initialize(name, value)
        @adjacents = Set.new
        @name = name
        @value = value
    end

    def to_s
        "#{name}(#{value}:#{total})"
    end
end

class Graph
    
    def initialize 
        @visited = {}
    end
    # We are dealing with an undirected graph,
    # so I increment the "adjacents" in both sides.
    # The depth first will work the same way with
    # a directed graph.
    def add_edge(node_a, node_b)
        node_a.adjacents << node_b
        node_b.adjacents << node_a
    end
    
    def breadth_first_traverse(node)
        queue = []
        visited = {}
        queue.push(node)
        while !queue.empty?
            node = queue.shift 
            yield node 
            node.adjacents.each do |child|
                next if visited[child]
                queue.push(child)
            end
            
            visited[node] = true
        end
    end
    
    def depth_first_traverse(node)
        queue = []
        visited = {}
        queue.push(node)
        while !queue.empty?
            node = queue.pop 
            yield node 
            node.adjacents.each do |child|
                next if visited[child]
                queue.push(child)
            end
            
            visited[node] = true
        end
    end
   
end

class Total
    def initialize(graph, source_node)
        @graph = graph
        @source_node = source_node
        @visited = []
        @edge_to = {}

    end
    
    def run
        total(@source_node)
    end
    
    private

    def total(node)
        @visited << node
        total = node.value
        node.adjacents.each do |adj_node|
            next if @visited.include?(adj_node)
            total += total(adj_node)
        end
        node.total = total
        total
    end


end

n = gets.strip.to_i 
values = gets.strip.split(/\s/).map(&:to_i)
nodes = Hash.new
values.each_with_index do |val, i| 
    nodes[i+1] = Node.new(i+1, val)
end
graph = Graph.new
1.upto(n-1).each do |i| 
    from, to = gets.strip.split(/\s/).map(&:to_i)
    from = nodes[from]
    to = nodes[to]
    graph.add_edge(from, to)
end

root = nodes[1]

nodes = []
graph.breadth_first_traverse(root) do |node| 
    nodes.push(node)
end

visited = {}

while !nodes.empty? 
    node = nodes.pop 
    visited[node] = true
    visited_children = node.adjacents.select { |child| visited[child] }
    node.total = node.value + visited_children.inject(0) { |total, node| total += node.total }
end


min = Float::INFINITY
total = root.total
min_node = nil
graph.breadth_first_traverse(root) do |node| 
    next if node == root 
    #puts node.to_s
    remaining = total - node.total 
    diff = (remaining - node.total).abs 
    if diff < min 
        min = diff 
        min_node = node
    end
end

puts min
