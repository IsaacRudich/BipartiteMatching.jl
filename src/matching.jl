"""
    findmaxcardinalitybipartitematching(am::BitArray{2})

Find a maximum cardinality bipartite matching using a breadth first search for augmenting paths
Return a matching of rows to columns and a list of matched col values ::Dict{Int, Int}, ::BitVector

# Arguments
- `am::BitArray{2}`: the bipartite graph (as an adjacency matrix)
"""
function findmaxcardinalitybipartitematching(am::BitArray{2})
    #initialize sorted information
    upperBound = min(size(am, 1), size(am, 2))

    #find an initial matching
    matching, matched = findgreedybipartitematching(am)

    #augment until upperBound is reached, or there are no augmenting paths 
    if length(matching)!=upperBound
        augmentingPath = findAugmentingPath(matching, matched, am)
        while !isnothing(augmentingPath)
            matching, matched = updateBipartiteMatching!(matching, matched, augmentingPath)
            if length(matching)==upperBound
                break
            else
                augmentingPath = findAugmentingPath(matching, matched, am)
            end
        end
    end

    return matching, matched
end

"""
    findgreedybipartitematching(am::BitArray{2})

Find a greedy bipartite matching by iteratively trying to pair each node 
in the first partition with a node in the second partition
Return a matching of rows to columns, and a list of matched col values ::Dict{Int, Int}, ::BitVector

# Arguments
- `am::BitArray{2}`: the bipartite graph
"""
function findgreedybipartitematching(am::BitArray{2})
    matching = Dict{Int, Int}()
    matched = falses(size(am, 2))
    for row in 1:size(am, 1)
        for col in 1:size(am, 2)
            if !matched[col] && am[row,col]
                matched[col] = true
                matching[row] = col
                break
            end
        end
    end
    return matching, matched
end

"""
    findAugmentingPath(matching::Dict{Int,Int}, matched::BitVector, am::BitArray{2})

Find an augmenting path to improve a bipartite matching by performing a breadth first search on the unmatched column nodes, one at a time
Return the path, or nothing if there isn't one ::Union{Vector{Int}, nothing}

# Arguments
- `matching::Dict{Int,Int}`: the matching to augment, (row => col)
- `matched::BitVector`: a list of matched columns
- `am::BitArray{2}`: the bipartite graph
"""
function findAugmentingPath(matching::Dict{Int,Int}, matched::BitVector, am::BitArray{2})
    for candidate in 1:size(am, 2)
        if !matched[candidate]
            colQueue = Vector{OneWayNodes}()
            push!(colQueue, OneWayNodes(candidate, nothing))
            rowQueue = Vector{OneWayNodes}()
            #start the breadth first search 
            markedRows = falses(size(am, 1))
            while !isempty(colQueue)
                for node in colQueue
                    #get all of the unmatched egdes that go to matched nodes
                    for (row,isConnected) in enumerate(am[:,node.label])
                        if isConnected
                            if !haskey(matching, row)
                                newNode = addLinkedNode!(node, row)
                                return getPath(newNode)
                            elseif !markedRows[row]
                                newNode = addLinkedNode!(node, row)
                                push!(rowQueue, newNode)
                                markedRows[row] = true
                            end
                        end
                    end
                end
                colQueue = Vector{OneWayNodes}()

                for node in rowQueue
                    #for each node, get the matched egdes
                    col = matching[node.label]
                    newNode = addLinkedNode!(node, col)
                    push!(colQueue, newNode)
                end
                rowQueue = Vector{OneWayNodes}()
            end
        end
    end

    return nothing
end
"""
    updateBipartiteMatching!(matching::Dict{Int,Int}, matched::BitVector, augmentingPath::Vector{Int})

Update a matching based on an augmenting path
Return the new matching of rows to columns, and a list of matched col values ::Dict{Int, Int}, ::BitVector

# Arguments
- `matching::Dict{Int,Int}`: the matching to update, (row => col)
- `matched::BitVector`: a list of matched columns
- `augmentingPath::Vector{Int}`: the augmenting path to use to update the matching
"""
function updateBipartiteMatching!(matching::Dict{Int,Int}, matched::BitVector, augmentingPath::Vector{Int})
    matched[last(augmentingPath)] = true
    for i in 1:2:length(augmentingPath)
        matching[augmentingPath[i]] = augmentingPath[i+1] 
    end
    return matching, matched
end