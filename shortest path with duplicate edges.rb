# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'set'
require 'pp'

def find_min(array)
    $min_i = $index = 0
    $min = Float::INFINITY
    while $index < array.length
        if array[$index].dist < $min
            $min = array[$index].dist
            $min_i = $index
        end
        $index += 1

    end
    $min_i
end

class Floyd
    # notre constructeur, on initialise la matrice des predecesseurs ici
    def initialize(graph = [], pre = [])
        # les variables avec des @ avant sont des attributs de notre objet.
        @graph = graph
        @pre = pre
        # pour 1 à n, on remplit notre matrice des prédecesseurs
        graph.each_index do |i|
            pre[i] = []
            graph.each_index do |j|
                # on utilise i+1 car notre index commence à 0 sinon.
                pre[i][j] = i + 1
            end
        end
    end

    # application de l'algorithme de floyd
    def traitement
        @graph.each_index do |k|
            @graph.each_index do |i|
                @graph.each_index do |j|
                    if (@graph[i][j] == "Ø") && (@graph[i][k] != "Ø" && @graph[k][j] != "Ø")
                        @graph[i][j] = @graph[i][k] + @graph[k][j]
                        @pre[i][j] = @pre[k][j]
                    elsif (@graph[i][k] != "Ø" && @graph[k][j] != "Ø") && (@graph[i][j] > @graph[i][k] + @graph[k][j])
                        @graph[i][j] = @graph[i][k] + @graph[k][j]
                        @pre[i][j] = @pre[k][j]
                    end
                end
            end
            # cela nous permet d'afficher chacune des itérations de k
            if $verbose == 1
                puts "\nk = #{k + 1}"
                output
            end
        end
    end

    # permet de gérer l'affichage de nos matrices
    def output
        puts '###############'
        puts 'Matrice A :'
        @graph.each_index do |i|
            # la fonction join nous permet d'qfficher online les éléments de notre tableau en précisant le separateur
            puts @graph[i].join(' | ')
        end
        puts '###############'
        puts 'Matrice P :'
        @pre.each_index do |i|
            puts @pre[i].join(' | ')
        end
        puts "\n"
    end

    def distance(source, target)
        return @graph[source - 1][target - 1] if @graph[source - 1][target - 1] != "Ø"
        -1
    end
end

class Graph
    Vertex = Struct.new(:name, :neighbours, :dist, :prev)

    def initialize(graph)
        @vertices = Hash.new { |h, k| h[k] = Vertex.new(k, Set.new, Float::INFINITY) }
        @edges = {}
        graph.each do |(v1, v2, dist)|
            next if !@edges[[v1, v2]].nil? && @edges[[v1, v2]] < dist
            @vertices[v1].neighbours.add(v2)
            @vertices[v2].neighbours.add(v1)
            @edges[[v1, v2]] = @edges[[v2, v1]] = dist
        end
        @dijkstra_source = nil
    end

    def add_vertex(vertex)
        @vertices[vertex]
    end

    def dijkstra(source)
        return if @dijkstra_source == source
        q = @vertices.values

        @vertices[source].dist = 0
        until q.empty?
            min_index = find_min(q)
            u = q[min_index]
            break if u.dist == Float::INFINITY
            q.delete_at(min_index)
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

    def shortest_distance(_source, target)
        @vertices[target].dist
    end

    def to_s
        '#<%s vertices=%p edges=%p>' % [self.class.name, @vertices.values, @edges]
    end
end

graphs = []
def dijkstra_read_graph(n_nodes, n_edges)
    graph = []
    set = Set.new (1..n_nodes).to_a
    while n_edges > 0
        line = gets.gsub(/\s+/m, ' ').strip.split(' ')
        graph.push([line[0], line[1], line[2].to_i])
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
    distances = []
    (1..n_nodes).each do |i|
        target = i.to_s
        next if target == source
        dist = g.shortest_distance(source, target)
        dist = -1 if dist == Float::INFINITY
        distances.push(dist)
    end

    puts distances.join(' ')
end

def floyd_read_graph(n_nodes, n_edges)
    graph = Array.new(n_nodes) { Array.new(n_nodes) { 'Ø' } }
    while n_edges > 0
        line = gets.gsub(/\s+/m, ' ').strip.split(' ')
        if graph[line[0].to_i - 1][line[1].to_i - 1] == 'Ø'
            graph[line[1].to_i - 1][line[0].to_i - 1] = graph[line[0].to_i - 1][line[1].to_i - 1] = line[2].to_i
        end

        if graph[line[0].to_i - 1][line[1].to_i - 1] > line[2].to_i
            graph[line[1].to_i - 1][line[0].to_i - 1] = graph[line[0].to_i - 1][line[1].to_i - 1] = line[2].to_i
        end
        n_edges -= 1
    end
    source = gets.strip.to_i
    objet = Floyd.new(graph)
    objet.traitement
    distances = []
    (1..n_nodes).each do |target|
        next if source == target
        distances.push(objet.distance(source, target))
    end

    puts distances.join(' ')
end

def read_graph
    n = gets.strip.to_i
    while n > 0
        n -= 1
        info = gets.gsub(/\s+/m, ' ').strip.split(' ')
        n_edges = info[1].to_i
        n_nodes = info[0].to_i
        if (n_edges * n_nodes**2) > n_nodes**3
            floyd_read_graph(n_nodes, n_edges)
        else
            dijkstra_read_graph(n_nodes, n_edges)
        end
    end
end

read_graph
