# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'set'

class PQueue

  #
  # Returns a new priority queue.
  #
  # If elements are given, build the priority queue with these initial
  # values. The elements object must respond to #to_a.
  #
  # If a block is given, it will be used to determine the priority between
  # the elements. The block must must take two arguments and return `1`, `0`,
  # or `-1` or `true`, `nil` or `false. It should return `0` or `nil` if the
  # two arguments are considered equal, return `1` or `true` if the first
  # argument is considered greater than the later, and `-1` or `false` if
  # the later is considred to be greater than the first.
  #
  # By default, the priority queue retrieves maximum elements first
  # using the #<=> method.
  #
  def initialize(elements=nil, &block) # :yields: a, b
    @que = []
    @cmp = block || lambda{ |a,b| a <=> b }
    replace(elements) if elements
  end

 protected

  #
  # The underlying heap.
  #
  attr_reader :que #:nodoc:

 public

  #
  # Priority comparison procedure.
  #
  attr_reader :cmp

  #
  # Returns the size of the queue.
  #
  def size
    @que.size
  end

  #
  # Alias of size.
  #
  alias length size

  #
  # Add an element in the priority queue.
  #
  def push(v)
    @que << v
    reheap(@que.size-1)
    self
  end

  #
  # Traditional alias for #push.
  #
  alias enq push

  #
  # Alias of #push.
  #
  alias :<< :push

  #
  # Get the element with the highest priority and remove it from
  # the queue.
  #
  # The highest priority is determined by the block given at instantiation
  # time.
  #
  # The deletion time is O(log n), with n is the size of the queue.
  #
  # Return nil if the queue is empty.
  #
  def pop
    return nil if empty?
    @que.pop
  end

  #
  # Traditional alias for #pop.
  #
  alias deq pop

  # Get the element with the lowest priority and remove it from
  # the queue.
  #
  # The lowest priority is determined by the block given at instantiation
  # time.
  #
  # The deletion time is O(log n), with n is the size of the queue.
  #
  # Return nil if the queue is empty.
  #
  def shift
    return nil if empty?
    @que.shift
  end

  #
  # Returns the element with the highest priority, but
  # does not remove it from the queue.
  #
  def top
    return nil if empty?
    return @que.last
  end

  #
  # Traditional alias for #top.
  #
  alias peek top

  #
  # Returns the element with the lowest priority, but
  # does not remove it from the queue.
  #
  def bottom
    return nil if empty?
    return @que.first
  end

  #
  # Add more than one element at the same time. See #push.
  #
  # The elements object must respond to #to_a, or be a PQueue itself.
  #
  def concat(elements)
    if empty?
      if elements.kind_of?(PQueue)
        initialize_copy(elements)
      else
        replace(elements)
      end
    else
      if elements.kind_of?(PQueue)
        @que.concat(elements.que)
        sort!
      else
        @que.concat(elements.to_a)
        sort!
      end
    end
    return self
  end

  #
  # Alias for #concat.
  #
  alias :merge! :concat

  #
  # Return top n-element as a sorted array.
  #
  def take(n=@size)
    a = []
    n.times{a.push(pop)}
    a
  end

  #
  # Returns true if there is no more elements left in the queue.
  #
  def empty?
    @que.empty?
  end

  #
  # Remove all elements from the priority queue.
  #
  def clear
    @que.clear
    self
  end

  #
  # Replace the content of the heap by the new elements.
  #
  # The elements object must respond to #to_a, or to be
  # a PQueue itself.
  #
  def replace(elements)
    if elements.kind_of?(PQueue)
      initialize_copy(elements)
    else
      @que.replace(elements.to_a)
      sort!
    end
    self
  end

  #
  # Return a sorted array, with highest priority first.
  #
  def to_a
    @que.dup
  end

  #
  # Return true if the given object is present in the queue.
  #
  def include?(element)
    @que.include?(element)
  end

  #
  # Push element onto queue while popping off and returning the next element.
  # This is qquivalent to successively calling #pop and #push(v).
  #
  def swap(v)
    r = pop
    push(v)
    r
  end

  #
  # Iterate over the ordered elements, destructively.
  #
  def each_pop #:yields: popped
    until empty?
      yield pop
    end
    nil
  end

  #
  # Pretty inspection string.
  #
  def inspect
    "<#{self.class}: size=#{size}, top=#{top || "nil"}>"
  end

  #
  # Return true if the queues contain equal elements.
  #
  def ==(other)
    size == other.size && to_a == other.to_a
  end

 private

  #
  #
  #
  def initialize_copy(other)
    @cmp  = other.cmp
    @que  = other.que.dup
    sort!
  end

  #
  # The element at index k will be repositioned to its proper place.
  #
  # This, of course, assumes the queue is already sorted.
  #
  def reheap(k)
    return self if size <= 1

    que = @que.dup

    v = que.delete_at(k)
    i = binary_index(que, v)

    que.insert(i, v)

    @que = que

    return self
  end

  #
  # Sort the queue in accorance to the given comparison procedure.
  #
  def sort!
    @que.sort! do |a,b|
      case @cmp.call(a,b)
      when  0, nil   then  0
      when  1, true  then  1
      when -1, false then -1
      else
        warn "bad comparison procedure in #{self.inspect}"
        0
      end
    end
    self
  end

  #
  # Alias of #sort!
  #
  alias heapify sort!

  #
  def binary_index(que, target)
    upper = que.size - 1
    lower = 0

    while(upper >= lower) do
      idx  = lower + (upper - lower) / 2
      comp = @cmp.call(target, que[idx])

      case comp
      when 0, nil
        return idx
      when 1, true
        lower = idx + 1
      when -1, false
        upper = idx - 1
      else
      end
    end
    lower
  end

end # class PQueue

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
