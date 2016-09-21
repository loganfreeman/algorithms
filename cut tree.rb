require 'set'

class Node
    attr_accessor :name, :adjacents, :value

    def initialize(name, value)
        @adjacents = Set.new
        @name = name
        @value = value
    end

    def to_s
        "#{name}(#{value})"
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

class DepthFirstSearch
    def initialize(graph, source_node)
        @graph = graph
        @source_node = source_node
        @visited = []
        @edge_to = {}

        dfs(source_node)
    end
    
    # After the depth-first search is done we can find
    # any vertice connected to "node" in constant time [O(1)]
    # and find a path to this node in linear time [O(n)].
    def path_to(node)
        return unless has_path_to?(node)
        path = []
        current_node = node

        while current_node != @source_node
            path.unshift(current_node)
            current_node = @edge_to[current_node]
        end

        path.unshift(@source_node)
    end

    private

    def dfs(node)
        @visited << node
        node.adjacents.each do |adj_node|
            next if @visited.include?(adj_node)

            dfs(adj_node)
            @edge_to[adj_node] = node
        end
    end

    def has_path_to?(node)
        @visited.include?(node)
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
graph.depth_first_traverse(root) do |node| 
    puts node.to_s
end
