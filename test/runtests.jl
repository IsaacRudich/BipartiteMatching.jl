using Test, BipartiteMatching

"""
    testrandommatching(rows::Int, cols::Int; density::Float64=.5)

Generate a random bipartite graph, find a matching, and make sure the matching is valid
Return true if the matching is valid, false otherwise

# Arguments
- `rows::Int`: the number of rows in the graph
- `cols::Int`: the number of columns in the graph
- `density::Float64`: the percent of edges included (default is 0.5)
"""
function testrandommatching(rows::Int, cols::Int; density::Float64=.5)
    am = falses(rows,cols)

    #generate random example
    for i in 1:rows
        for j in 1:cols
            num = rand()
            if num <= density
                am[i,j] = true
            end
        end
    end

    matching, matched = findmaxcardinalitybipartitematching(am)

    for (key,value) in matching
        if !am[key,value]
            return false
        end
    end
    return true
end

@testset "RandomMatchings" begin
    for i in 1:10
        @test testrandommatching(1000,1000,density = .1)
    end
end