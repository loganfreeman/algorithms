# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'set'
require 'pp'

class LazyPriorityQueue
  Node = Struct.new :element,
                    :key,
                    :rank,
                    :parent,
                    :left_child,
                    :right_sibling

  def initialize(top_condition, &heap_property)
    @top = nil
    @roots = []
    @references = {}
    @top_condition = top_condition
    @heap_property = heap_property
  end

  def enqueue(element, key)
    if @references[element]
      raise 'The provided element already is in the queue.'
    end

    node = Node.new element, key, 0

    @top = @top ? select(@top, node) : node
    @roots << node
    @references[element] = node

    element
  end
  alias push enqueue
  alias insert enqueue

  def change_priority(element, new_key)
    node = @references[element]

    raise 'Element provided is not in the queue.' unless node

    test_node = node.clone
    test_node.key = new_key

    unless @heap_property[test_node, node]
      raise 'Priority can only be changed to a more prioritary value.'
    end

    node.key = new_key
    node = sift_up node
    @top = select(@top, node) unless node.parent

    element
  end

  def peek
    @top && @top.element
  end

  def dequeue
    return unless @top

    element = @top.element
    @references.delete element
    @roots.delete @top

    child = @top.left_child

    while child
      next_child = child.right_sibling
      child.parent = nil
      child.right_sibling = nil
      @roots << child
      child = next_child
    end

    @roots = coalesce @roots
    @top = @roots.inject { |top, node| select(top, node) }

    element
  end
  alias pop dequeue

  def delete(element)
    change_priority element, @top_condition
    dequeue
  end

  def empty?
    @references.empty?
  end

  def size
    @references.size
  end
  alias length size

  private

  def sift_up(node)
    return node unless node.parent && !@heap_property[node.parent, node]

    node.parent.key, node.key = node.key, node.parent.key
    node.parent.element, node.element = node.element, node.parent.element

    @references[node.element] = node
    @references[node.parent.element] = node.parent

    sift_up node.parent
  end

  def select(parent_node, child_node)
    @heap_property[parent_node, child_node] ? parent_node : child_node
  end

  def coalesce(trees)
    coalesced_trees = []

    while tree = trees.pop
      if coalesced_tree = coalesced_trees[tree.rank]
        # This line must go before than...
        coalesced_trees[tree.rank] = nil
        # ...this one.
        trees << add(tree, coalesced_tree)
      else
        coalesced_trees[tree.rank] = tree
      end
    end

    coalesced_trees.compact
  end

  def add(node_one, node_two)
    if node_one.rank != node_two.rank
      raise 'Both nodes must hold the same rank.'
    end

    if node_one.parent || node_two.parent
      raise 'Both nodes must be roots (no parents).'
    end

    adder_node, addend_node =
      if @heap_property[node_one, node_two]
        [node_one, node_two]
      else
        [node_two, node_one]
      end

    addend_node.parent = adder_node

    # This line must go before than...
    addend_node.right_sibling = adder_node.left_child
    # ...this one.
    adder_node.left_child = addend_node

    adder_node.rank += 1

    adder_node
  end
end

class MinPriorityQueue < LazyPriorityQueue
  def initialize
    super(-Float::INFINITY) do |parent_node, child_node|
      parent_node.key <= child_node.key
    end
  end

  alias decrease_key change_priority
  alias min peek
  alias extract_min dequeue
end

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
        
        visited = Set.new
        
        queue = MinPriorityQueue.new
        
        q.each do |v|
            queue.push v.name, v.dist
        end
        
        until queue.empty?
            u = @vertices[queue.min]
            break if u.dist == Float::INFINITY
            queue.pop
            u.neighbours.each do |v|
                vv = @vertices[v]
                next if visited.include?(vv.name)
                alt = u.dist + @edges[[u.name, v]]
                if alt < vv.dist
                    vv.dist = alt
                    vv.prev = u.name
                    queue.decrease_key vv.name, vv.dist
                end
            end
            visited.add(u.name)
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
    while n_edges > 0
        line = gets.gsub(/\s+/m, ' ').strip.split(' ')
        graph.push([line[0], line[1], line[2].to_i])
        n_edges -= 1
    end
    source = gets.strip
    g = Graph.new(graph)
    
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
        dijkstra_read_graph(n_nodes, n_edges)
    end
end

read_graph
