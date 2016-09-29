package org.langera.graph

class Graph {

    Vertex vertex

    static class Vertex {

        boolean visited = false
        String id
        List<Vertex> neighbours = []

        @Override
        String toString() {
            id
        }
    }

    List<Graph.Vertex> bfs() {
        return bfs({})
    }


    List<Graph.Vertex> bfs(Closure visitor) {
        List<Graph.Vertex> walk = []
        vertex.visited = true
        visitor.call(vertex)
        Queue<Graph.Vertex> queue = new LinkedList<Graph.Vertex>()
        queue.addLast(vertex)
        while (!queue.isEmpty()) {
            Graph.Vertex v = queue.removeFirst()
            walk << v
            v.neighbours.each { Graph.Vertex n ->
                if (!n.visited) {
                    n.visited = true
                    visitor.call(n)
                    queue.addLast(n)
                }
            }
        }
        return walk
    }

    List<Graph.Vertex> dfsWithStack() {
        List<Graph.Vertex> walk = []
        vertex.visited = true
        Queue<Graph.Vertex> queue = new LinkedList<Graph.Vertex>()
        queue.push(vertex)
        while (!queue.isEmpty()) {
            Graph.Vertex v = queue.pop()
            if (v.neighbours.isEmpty() || !v.neighbours.find { Graph.Vertex n -> n.visited }) {
                walk << v
            }
            Graph.Vertex next = v.neighbours.find { Graph.Vertex n -> !n.visited }
            if (next) {
                if (v.neighbours.find { Graph.Vertex n -> !n.visited }) {
                    queue.push(v)
                }
                next.visited = true
                queue.push(next)
            }
        }
        return walk
    }

    List<Graph.Vertex> dfsRecursive() {
        List<Graph.Vertex> walk = []
        dfsRecursiveInternal(vertex, walk)
        return walk
    }

    private void dfsRecursiveInternal(Graph.Vertex v, List<Graph.Vertex> walk) {
        v.visited = true
        walk.add(v)
        v.neighbours.each { Graph.Vertex n ->
            if (!n.visited) {
                dfsRecursiveInternal(n, walk)
            }
        }
    }

    boolean hasCycle() {
        List<Vertex> topologicallySorted = dfsWithStack()
        boolean cycle = false
        bfs() { Vertex vertex ->

            int vertexIndex = topologicallySorted.findIndexOf { it == vertex }

            vertex.neighbours.each { n ->
                int nIndex = topologicallySorted.findIndexOf { it == n }
                cycle |= (nIndex <= vertexIndex)
            }
        }
        return cycle
    }
}
