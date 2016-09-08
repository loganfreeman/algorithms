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
                next unless q.include?(vv)
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

    def shortest_distance(source, target)
        dijkstra(source)
        @vertices[target].dist
    end

    def to_s
        '#<%s vertices=%p edges=%p>' % [self.class.name, @vertices.values, @edges]
    end
end

graphs = []
def read_graph
    n = gets.strip.to_i
    while n > 0
        n -= 1
        graph = []
        info = gets.gsub(/\s+/m, ' ').strip.split(' ')
        n_edges = info[1].to_i
        n_nodes = info[0].to_i
        set = Set.new (1..n_nodes).to_a
        while n_edges > 0
            line = gets.gsub(/\s+/m, ' ').strip.split(' ')
            graph.push([line[0], line[1], 6])
            set.delete(line[0].to_i)
            set.delete(line[1].to_i)
            n_edges -= 1
        end
        source = gets.strip
        g = Graph.new(graph)
        set.each do |vertex|
            g.add_vertex(vertex.to_s)
        end

        g.dijkstra(source)
        vertices = g.vertices.map(&:to_i).sort
        distances = []
        until vertices.empty?
            target = vertices.shift.to_s
            next if target == source
            dist = g.shortest_distance(source, target)
            dist = -1 if dist == Float::INFINITY
            distances.push(dist)
        end
        puts distances.join(' ')
    end
end

read_graph
