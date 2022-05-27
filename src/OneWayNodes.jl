struct OneWayNodes
    label           ::Int
    link            ::Union{OneWayNodes, Nothing}
end

"""
    addLinkedNode!(node::OneWayNodes, label::Int)

Add a node of type OneWayNodes with a link to another node
Return the new node ::OneWayNodes

# Arguments
- `node::OneWayNodes`: the node to link to
- `label::Int`: the label of the new node
"""
function addLinkedNode!(node::OneWayNodes, label::Int)
    linkedNode = OneWayNodes(label,node)
    return linkedNode
end

"""
    getPath(node::OneWayNodes)

Find the path from a node to its endPoint
Return the path ::Vector{Int}

# Arguments
- `node::OneWayNodes`: the end of the path
"""
function getPath(node::OneWayNodes)
    path = Int[node.label]

    while !isnothing(node.link)
        node = node.link
        push!(path, node.label)
    end

    return path
end