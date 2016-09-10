Given a directed, weighted graph, consisting of  nodes and there are edges ,of specified length between some of them in the graph.

Given  questions, inquring the shortest distance between a queried pair of nodes in the graph.

Answer all these questions as quickly as possible !

Input Format

First line has two integers , denoting the number of nodes in the graph and , denoting the number of edges in the graph. 
The next  lines each consist of three space separated integers   , where  and  denote the two nodes between which the directed edge  exists,  denotes the length of the edge between the corresponding edges. 
The next line contains a single integer , denoting number of queries. 
The next  lines each, contain two space separated integers  and , denoting the node numbers specified according to the question.

Constraints 
 
 
 
 

If there are edges between the same pair of nodes with different weights, the last one (most recent) is to be considered as the only edge between them.


```ruby
# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'pp'
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
        return 0 if source == target
        return @graph[source - 1][target - 1] if @graph[source - 1][target - 1] != "Ø"
        -1
    end
end

def floyd_read_graph(n_nodes, n_edges)
    graph = Array.new(n_nodes) { Array.new(n_nodes) { 'Ø' } }
    while n_edges > 0
        line = gets.gsub(/\s+/m, ' ').strip.split(' ')
        if graph[line[0].to_i - 1][line[1].to_i - 1] == 'Ø'
            graph[line[0].to_i - 1][line[1].to_i - 1] = line[2].to_i
        end

        if graph[line[0].to_i - 1][line[1].to_i - 1] > line[2].to_i
            graph[line[0].to_i - 1][line[1].to_i - 1] = line[2].to_i
        end
        n_edges -= 1
    end
    objet = Floyd.new(graph)
    objet.traitement
    # objet.output
    objet
end

N, M = gets.strip.split(' ').map(&:to_i)
graph = floyd_read_graph(N, M)
n = gets.strip.to_i
while n > 0
    n -= 1
    from, to = gets.strip.split(' ').map(&:to_i)
    puts graph.distance(from, to)
end
```
