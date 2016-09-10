Given a graph which consists of several edges connecting the  nodes in it. 
It is required to find a subgraph of the given graph with the following properties:

- The subgraph contains all the nodes present in the original graph.
- The subgraph is of minimum overall weight (sum of all edges) among all such subgraphs.
- It is also required that there is exactly one, exclusive path between any two nodes of the subgraph.

One specific node  is fixed as the starting point of finding the subgraph. 
Find the total weight of such a subgraph (sum of all edges in the subgraph)

Input Format

First line has two integers , denoting the number of nodes in the graph and , denoting the number of edges in the graph.

The next  lines each consist of three space separated integers   , where  and  denote the two nodes between which the undirected edge exists,  denotes the length of edge between the corresponding nodes.

The last line has an integer , denoting the starting node.

```ruby
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
        "#{node1} <=> #{node2} with weight #{weight}"
    end
end

class Graph
    attr_accessor :nodes
    attr_accessor :edges
    attr_accessor :edges_hash

    def initialize
        @nodes = []
        @edges = []
        @edges_hash = {}
    end

    def add_node(node)
        nodes << node
        node.graph = self
    end

    def add_edge(from, to, weight)
        if edges_hash.include? [from, to]
            edges_hash[[from, to]].weight = weight if edges_hash[[from, to]].weight > weight
        else
            edge = Edge.new(from, to, weight)
            edges_hash[[from, to]] = edge
            edges << edge
        end
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
            unless union_find.connected?(edge.node1, edge.node2)
                union_find.union(edge.node1, edge.node2)
                mst << edge
            end
        end

        mst
    end
end

N, M = gets.strip.split(' ').map(&:to_i)
i = 1
graph = Graph.new
hash = Hash.new
while i <= N
    node = Node.new(i)
    graph.add_node(node)
    hash[i] = node
    i += 1
end
i = 1
while i <= M
    from, to, weight = gets.strip.split(' ').map(&:to_i)
    graph.add_edge(hash[from], hash[to], weight)
    graph.add_edge(hash[to], hash[from], weight)
    i += 1
end

pp Kruskal.new.compute_mst(graph).map(&:weight).reduce(:+)
```
