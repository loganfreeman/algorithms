# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'set'

class Graph
    Vertex = Struct.new(:name, :neighbours, :dist, :prev)

    def initialize(graph)
        @vertices = Hash.new { |h, k| h[k] = Vertex.new(k, [], Float::INFINITY) }
        @edges = {}
        graph.each do |(v1, v2, dist)|
            @vertices[v1].neighbours << v2
            @vertices[v2].neighbours << v1
            @edges[[v1, v2]] = @edges[[v2, v1]] = dist
        end
        @dijkstra_source = nil
    end

    def add_vertex(vertex)
        return if @vertices.keys.include? vertex
        @vertices[vertex]
    end

    def vertices
        @vertices.keys
    end

    def dijkstra(source)
        return if @dijkstra_source == source
        q = @vertices.values
        q.each do |v|
            v.dist = Float::INFINITY
            v.prev = nil
        end
        @vertices[source].dist = 0
        until q.empty?
            u = q.min_by(&:dist)
            break if u.dist == Float::INFINITY
            q.delete(u)
            u.neighbours.each do |v|
                vv = @vertices[v]
                alt = u.dist + @edges[[u.name, v]]
                if alt < vv.dist
                    vv.dist = alt
                    vv.prev = u.name
                end
            end
        end
        @dijkstra_source = source
    end

    def shortest_path(source, target)
        dijkstra(source)
        path = []
        u = target
        while u
            path.unshift(u)
            u = @vertices[u].prev
        end
        [path, @vertices[target].dist]
    end

    def shortest_distance(target)
        @vertices[target].dist
    end

    def to_s
        '#<%s vertices=%p edges=%p>' % [self.class.name, @vertices.values, @edges]
    end
end

graphs = []
def read_graph
        graph = []
        n_nodes, n_edges = gets.gsub(/\s+/m, ' ').strip.split(' ').map(&:to_i)
        while n_edges > 0
            from, to, weight = gets.gsub(/\s+/m, ' ').strip.split(' ').map(&:to_i)
            graph.push([from, to, 2**weight])
            n_edges -= 1
        end
        g = Graph.new(graph)

        sum = 0
    1.upto(n_nodes-1).each do |from| 
        g.dijkstra(from)
        (from+1).upto(n_nodes).each do |to| 
            sum += g.shortest_distance(to)
        end
    end
    
    puts sum.to_s(2)
end

read_graph
