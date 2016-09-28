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


def floyd_read_graph(n_nodes, n_edges)
    graph = Array.new(n_nodes) { Array.new(n_nodes) { 'Ø' } }
    while n_edges > 0
        from, to, weight = gets.gsub(/\s+/m, ' ').strip.split(' ').map(&:to_i)
        graph[from - 1][to - 1] = graph[to - 1][from - 1] = 2**weight
        n_edges -= 1
    end
    objet = Floyd.new(graph)
    objet.traitement
    distances = []
    sum = 0
    (1..n_nodes-1).each do |source|
        (source+1..n_nodes).each do |target| 
            next if source == target
            sum += objet.distance(source, target)
        end
    end

    puts sum.to_s(2)
end

def read_graph
    info = gets.gsub(/\s+/m, ' ').strip.split(' ')
    n_edges = info[1].to_i
    n_nodes = info[0].to_i
    floyd_read_graph(n_nodes, n_edges)
end

read_graph
