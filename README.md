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

The project includes graph generation utilities that can create random directed graphs with configurable parameters. These graphs are made reproducible by using the number of nodes to generate as the seed for the random number generator.


## Project Structure

```
pathfinder/
├── main.odin              # Entry point and CLI
├── types.odin             # Type definitions (Edge, Graph)
├── graphGenerator.odin    # Graph generation functions
├── algorithms.odin        # Pathfinding algorithms
└── utils.odin             # Utility functions (path reconstruction, graph printing)
```


## Building and Running

### Build and Run

```bash
odin run .
```

Or with arguments:

```bash
odin run . [OPTIONS] [NUM_NODES] [MIN_EDGES] [MAX_EDGES] [MIN_WEIGHT] [MAX_WEIGHT]
```


### Usage

```
Usage: pathfinder [OPTIONS] [NUM_NODES] [MIN_EDGES] [MAX_EDGES] [MIN_WEIGHT] [MAX_WEIGHT]

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

# Verbose output
odin run . 200 --verbose

# Allow negative cycles
odin run . 100 -n -v
```


## Further Ideas
When dealing with a graph with non-negative weighted edges, the [Dijkstra](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) is the go-to algorithm with its $O(m + n log n)$ time bound on sparse graphs. Recently [Duan et al. (2025)](https://arxiv.org/abs/2504.17033) presented a deterministic $O(m log^{2/3} n)$ -time algorithm for single-source shortest paths (SSSP) on directed graphs with real non-negative edge weights, showing that Dijkstra's algorithm is not optimal for SSSP.


## Resources
- [Kubica (2025) "Graph Algorithms The Fun Way"](https://nostarch.com/graph-algorithms-fun-way)
- [Odin Lang Docs](https://odin-lang.org/docs/)
- [Duan et al. (2025)](https://arxiv.org/abs/2504.17033)
