module DisjointSet
  # DisjointSet
  class DisjointSet
    attr_reader :parent, :rank

    def initialize(ids = [])
      @parent, @rank = {}, {}
      ids.each do |id|
        @parent[id] = id
        @rank[id] = 0
      end
    end

    def make_set(x)
      @parent[x] = x
      @rank[x] = 0
    end

    def find(x)
      return x if (@parent[x] == x)
      @parent[x] = find(@parent[x])
      @parent[x]
    end

    def union(x, y)
      x, y, rank_x, rank_y =
        find(x), find(y), @rank[x], @rank[y]

      return if (x == y)

      if (rank_x > rank_y)
        @parent[y] = x
      elsif (rank_x < rank_y)
        @parent[x] = y
      else
        @parent[y] = x
        @rank[x] += 1
      end
    end

    def same?(x, y)
      find(x) == find(y)
    end
  end
end
