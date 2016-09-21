# Enter your code here. Read input from STDIN. Print output to STDOUT

module AStar
    Edge = Struct.new(:cost, :child)

    class CartesianNode
        attr_accessor :g, :h, :parent, :edges, :enabled
        attr_reader :x, :y, :hash # once initialized, the location of the node is immutable.

        def initialize(x, y)
            @x = x
            @y = y # Stores the Cartesian coordinates for this node.
            @g = 0 # Stores distance from the starting node to the current node
            @edges = [] # An array of edge structs storing references to any adjacent nodes.
            @enabled = true # If set to false, this node is 'impassible' and cannot be traversed.

            @hash = [@x, @y].hash # create a hash value used when storing the node as a hash key.
        end

        def ==(other)
            @hash == other.hash
        end

        def h(goal) # Stores a heuristic estimate of the distance remaining to the goal node.
            @h ||= AStar.manhattan_distance(self, goal)
        end

        def f(goal) # Estimates the value of the current path being taken based on the actual distance
            @g + h(goal) # to this node from the start and the estimated distance remaining to the goal.
        end

        def inspect
            "<N (#{@x},#{@y})>"
        end
    end

    class CartesianGraph # Creates an interconnected Cartesian graph of (width)**2 nodes.
        def initialize(height, width) # Each node is linked to all adjacent nodes at initialization.
            @width = width
            @height = height
            @nodes = Array.new(height) { |y| Array.new(width) { |x| CartesianNode.new(x, y) } }
            link_nodes
      end

        def each # iterate over all nodes in the graph.
            @nodes.each_with_index do |row, _y|
                row.each_with_index do |node, _x|
                    yield(node)
                end
            end
        end

        def to_h
            @nodes.flatten.inject({}) { |hsh, node| hsh[node] = true; hsh }
        end

        def [](x, y) # Get a node by its Cartesian coordinates.
            @nodes[y][x]
        end

        def disable(x, y) # Disable the node at the given coordinates.
            @nodes[y][x].enabled = false
        end

        def enable(x, y)  # Enable the node at the given coordinates.
            @nodes[y][x].enabled = true
        end

        GRAPHICS = { open: ".", blocked: "X", start: "M", goal: "*", pv: "\u0298" }.freeze

        def print(start = nil, goal = nil, pv = nil) # Prints out the graph along with the path taken from the
            if pv.nil? || pv.empty? # start node to the goal, if given.
                pv = {}
            else
                puts "\n"
                p pv # Print out the path taken to the goal
                pv = pv.inject({}) { |hsh, node| hsh[node] = true; hsh }
            end
            puts separator = '|--' + '-' * (4 * @width - 3) + '--|'
            @nodes.each do |row|
                line = '|  ' + row.map do |node|
                    if !node.enabled
                        GRAPHICS[:blocked]
                    elsif node == start
                        GRAPHICS[:start]
                    elsif node == goal
                        GRAPHICS[:goal]
                    elsif pv[node]
                        GRAPHICS[:pv]
                    else
                        GRAPHICS[:open]
                    end
                end.join('   ') + '  |'
                puts line, separator
            end
        end

        private

        def link_nodes # Iterates over all nodes in the graph, adding a reference to each adjacent node
            each do |node| # along with a movement cost representing the distance between the nodes.
                (-1..1).each do |y_offset|
                    (-1..1).each do |x_offset|
                        next if x_offset.abs + y_offset.abs == 2 # no diagonal walk
                        y = node.y + y_offset
                        x = node.x + x_offset
                        if 0 <= x && x < @width && 0 <= y && y < @height && (x_offset != 0 || y_offset != 0)
                            other = @nodes[y][x]
                            node.edges << Edge.new(AStar.distance(node, other), other)
                        end
                    end
                end
            end
        end
    end

    def self.manhattan_distance(from, to) # Returns the movement cost of going directly from one
        (from.y - to.y).abs + (from.x - to.x).abs # node to another without allowing diagonal movement.
    end

    def self.distance(from, to) # Returns the actual straight-line distance between the two nodes.
        ((from.y - to.y).abs**2 + (from.x - to.x).abs**2)**(1 / 2.0)
    end
end

module AStar
    def self.retrieve_pv(active, _from) # Re-trace our steps from the current node
        pv = [] # back to the starting node.
        until active.parent.nil?
            pv << active
            active = active.parent
        end
        pv.reverse!
    end

    def self.search(start, goal)
        open = {}
        closed = {}
        active = start
        open.store(start, true) # Add the starting node to the open set.

        until open.empty? # Keep searching until we reach the goal or run out of reachable nodes.
            active = open.min_by { |node, _value| node.f(goal) }.first # try the most promising nodes first.
            return retrieve_pv(active, start) if active == goal # Stop searching once the goal is reached.

            open.delete(active) # Move the active node from the open set to the closed set.
            closed.store(active, true)

            next unless active.enabled # if this node is impassible, ignore it and move on to the next child.

            active.edges.each do |edge|
                child = edge.child
                next if closed[child] # ignore child nodes that have already been expanded.

                g = active.g + edge.cost # get the cost of the current path to this child node.

                # If the child node hasn't been tried or if the current path to the child node is shorter
                # than the previously tried path, save the g value in the child node.
                next unless !open[child] || g < child.g
                child.parent = active # save a reference to the parent node
                child.g = g
                child.h(goal)
                open.store(child, true) unless open[child]
            end
        end

        puts "No path from #{start} to #{goal} was found."
        nil
    end
end

n = gets.strip.to_i
def read_graph
    height, width = gets.strip.split(/\s/).map(&:to_i)
    graph = AStar::CartesianGraph.new(height, width)
    goal = start = steps = nil
    0.upto(height-1).each do |r| 
        row = gets.strip.split('')
        row.each_with_index do |v, c| 
            if v == 'X'
                graph.disable(c, r)
            elsif v == '*'
                goal = [c, r]
            elsif v == 'M'
                start = [c, r]
            end
            
        end
    end
    steps = gets.strip.to_i
    start = graph[start[0], start[1]]
    goal = graph[goal[0], goal[1]]
    pv = AStar::search(start, goal)
    graph.print(start, goal, pv)
end
while n > 0
    n -= 1
    read_graph
end



