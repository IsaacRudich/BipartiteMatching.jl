# BipartiteMatching.jl
There are many algorithms in other Julia packages capable of finding maximum cardinality matches in bipartite graphs. However, those algorithms are very general, and mostly use linear programming or generic flow algorithms. For most small instances of bipartite matching those algorithms will work fine, but they do not scale nearly as well on large problems as algorithms optimized for bipartite graphs. This package provides a method of finding max cardinality matches that performs well on both very small and very large bipartite graphs.

## Installation
Installation is straightforward: enter Pkg mode by hitting `]`, and then
```julia-repl
(v1.0) pkg> add BipartiteMatching
```

## How to use this Package
There are two available functions:
  * ```findmaxcardinalitybipartitematching``` returns a maximum cardinality matching.
  * ```findgreedybipartitematching``` returns a matching that is not necessarily optimal, but may be slightly faster than ```findmaxcardinalitybipartitematching```.
 
Both functions take in a 2-d BitArray (```BitArray{2}```) representing the adjacency matrix for a bipartite graph. In other words, the value at row i column j of the BitArray should be 1 if and only if node i is connected to node j in your bipartite graph. The BitArray does not need to be square, for example you could match a set of 100 to a set of 10 using a 100x10 BitArray. However, the algorithm may perform at drastically different speeds when solving a 100x10 BitArray compared to a 10x100 BitArray. For optimal performance, initiate your BitArray with fewer columns than rows when the BitArray is not sqaure.
 
 Both functions return 2 values:
  * A ```Dict{Int, Int}``` containing a matching of rows to columns. In other words, the key value pair ```(i => j)``` means that edge ```(i,j)``` was used in the matching. 
  * A ```BitVector``` containing the matched column indices. In other words, if the ```Dict{Int, Int}``` contains the key value pair ```(i => j)```, then position j of the ```BitVector``` will be equal to 1 (and 0 otherwise). 


## The Algorithm 
The algorithm used for this package is a breadth-first search for [augmenting paths](https://en.wikipedia.org/wiki/Hopcroft%E2%80%93Karp_algorithm#Augmenting_paths), which is shown to be fast in practice in the paper *Sequential and Parallel Experimental Results with Bipartite Matching Algorithms* by *Joao C. Setubal*. The algorithm is implemented nearly as described in the aforementioned paper, but it has one added procedure. While, [Hopcroft-Karp](https://en.wikipedia.org/wiki/Hopcroft%E2%80%93Karp_algorithm#Algorithm) is known to be slower in practice than a breadth first search, the obervations used to construct the Hopcroft-Karp algorithm can be used to speed up a breadth-first search by running different sub-routines depending on which part of the augmenting path the breadth-first search is on. I have not found any mention of this in existing literature, but I would be surprised if it was an original observation. 

## Performance
The following data was collected on my laptop which has a 2.6 GHz Quad-Core Intel Core i7 processor. For each listed time, 100 graphs were created randomly (10 for the 2<sup>18</sup> node graphs), and the average solve time was reported. The values in the *number of nodes* column are the number of total nodes in the graph being solved. The density is the percent of maximum possible edges that were incuded in the graph. Solve times are reported in seconds for each category.

| Number of Nodes  | Density = 10% |  Density = 50% | Density = 90% |
| :-------------: | :-------------: | :-------------: | :-------------: |
| 2<sup>10</sup> | .00049 | .00025 | .00021 |
| 2<sup>12</sup> | .0031 | .0028 | .0027 |
| 2<sup>14</sup> | .049 | .051 | .055 |
| 2<sup>16</sup> | 0.71 | 0.71 | 0.64 |
| 2<sup>18</sup> | 9.69 | 9.58 | 9.59 |

## Citing
I encourage you to cite this work if you use this library.

Starring the repository on GitHub is also appreciated.
