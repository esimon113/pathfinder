# Pathfinder

This repo is a personal learning project focussed on implementing some graph algorithms while improving my skills in:
- Algorithms and Datastructures
- The [Odin Programming Language](https://odin-lang.org/)
- [Neovim](https://neovim.io/) as a dev environment

My main goal is to understand the algorithms and have some fun playing around...

> Odin is a general-purpose programming language with distinct typing built for high performance, modern systems and data-oriented programming.

> Odin is the C alternative for the Joy of Programming.


## Features

This project implements several graph pathfinding algorithms:

- **BFS (Breadth-First Search)**: Finds shortest paths in unweighted graphs
- **Dijkstra's Algorithm**: Finds shortest paths in graphs with non-negative edge weights
- **Bellman-Ford Algorithm**: Finds shortest paths in graphs that may contain negative edge weights (but no negative cycles)
- Floyd-Warshall Algorithm: Solves all-pairs shortest-path problem for graphs containing both positive and negative edges, but also no negative cycles

The project includes graph generation utilities that can create random directed graphs with configurable parameters. These graphs are made reproducible by using the number of nodes to generate as the seed for the random number generator.


## Project Structure

```
pathfinder/
├── main.odin              # Entry point and CLI
├── types.odin             # Type definitions (Edge, Graph)
├── graphGenerator.odin    # Graph generation functions
├── shortestPaths.odin     # Pathfinding algorithms
└── utils.odin             # Utility functions (path reconstruction, graph printing)
```


## Building and Running

### Build and Run

```bash
odin run .
```

Or with arguments:

```bash
odin run . [NUM_NODES] [MIN_EDGES] [MAX_EDGES] [MIN_WEIGHT] [MAX_WEIGHT] [START_NODE_ID] [DESTINATION_NODE_ID] [OPTIONS]
```


### Usage

```
Usage: pathfinder [NUM_NODES] [MIN_EDGES] [MAX_EDGES] [MIN_WEIGHT] [MAX_WEIGHT] [START_NODE_ID] [DESTINATION_NODE_ID] [OPTIONS]

Options:
  -h, --help              Show this help message
  -n, --negative-cycles   Allow negative cycles in graph generation
  -v, --verbose           Print the generated graph

Positional Arguments:
  NUM_NODES                Number of nodes in the graph (default: 100)
  MIN_EDGES                Minimum edges per node (default: 1)
  MAX_EDGES                Maximum edges per node (default: 10)
  MIN_WEIGHT               Minimum edge weight (default: -10.0)
  MAX_WEIGHT               Maximum edge weight (default: 10.0)
  START_NODE_ID            Start NodeId for the path calculation (default: 0)
  DESTINATION_NODE_ID      Destination NodeId for the path calculation (default: 2)
```


### Examples

```bash
# Run with default parameters
odin run .

# Show help
odin run . --help

# Generate a graph with 200 nodes
odin run . 200

# Custom graph parameters
odin run . 200 2 15 -5.0 5.0

# Custom graph with specific start and destination nodes
odin run . 200 2 15 -5.0 5.0 0 42

# Verbose output
odin run . 200 --verbose

# Allow negative cycles
odin run . 100 -n -v
```


## Inspirations / Future Ideas

### Shortest Paths
- ~~[Floyd-Warshall Algorithm](https://en.wikipedia.org/wiki/Floyd%E2%80%93Warshall_algorithm)~~
- [A* Search Algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm)
- [Johnson's Algorithm](https://en.wikipedia.org/wiki/Johnson%27s_algorithm)
- [Duan et al. (2025)](https://arxiv.org/abs/2504.17033)

### Minimum Spanning Tree (greedy algorithms)
- [Kruskal's Algorithm](https://en.wikipedia.org/wiki/Kruskal%27s_algorithm)
- [Prim's Algorithm](https://en.wikipedia.org/wiki/Prim%27s_algorithm)

### Max-Flow Algorithms
- [Ford-Fulkerson Algorithm](https://en.wikipedia.org/wiki/Ford%E2%80%93Fulkerson_algorithm)
- [Dinic's Algorithm](https://en.wikipedia.org/wiki/Dinic%27s_algorithm)

### Strongly Connected Components
- [Kosaraju-Sharir's Algorithm](https://en.wikipedia.org/wiki/Kosaraju%27s_algorithm)
- [Trajan's Algorithm](https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm)

### Topological Sort
- [Kahn's Algorithm](https://medium.com/@kartikgeu/kahns-algorithm-a-step-by-step-guide-to-topological-sorting-in-graphs-6c16fd44d78d)

### Graph Coloring Algorithms
- [Greedy Algorihtm](https://en.wikipedia.org/wiki/Greedy_coloring)
- [Welsh-Powell Algorithm](https://www.tutorialspoint.com/welsh-powell-graph-colouring-algorithm)
- [DSATUR](https://towardsdatascience.com/the-graph-coloring-problem-exact-and-heuristic-solutions-169dce4d88ab/)
- [Backtracking](https://pencilprogrammer.com/algorithms/graph-coloring-problem/)

### Tours through Graphs
- [Hamiltonian Paths](https://en.wikipedia.org/wiki/Hamiltonian_path)
- [Eulerian Paths and Cycles](https://www.geeksforgeeks.org/dsa/eulerian-path-and-circuit/)
- [The Travelling Salesperson Problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem)

### Other
- [LEACH Algorithm](https://en.wikipedia.org/wiki/Low-energy_adaptive_clustering_hierarchy)
- [Directed Diffusion Algorithm](https://www.sciencedirect.com/topics/computer-science/directed-diffusion)
- Algorithm visualization: Build some sort of GUI
- Benchmarks


## Resources / Interesting
- [Kubica (2025) "Graph Algorithms The Fun Way"](https://nostarch.com/graph-algorithms-fun-way)
- [Odin Lang Docs](https://odin-lang.org/docs/)
- [Duan et al. (2025)](https://arxiv.org/abs/2504.17033)
- [Daanoune et al. (2021)](https://www.sciencedirect.com/science/article/abs/pii/S1570870520307356)

