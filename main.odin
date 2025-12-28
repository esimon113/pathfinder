package main

import "core:fmt"
import "core:math/rand"


Edge :: struct {
	to:     u64,
	weight: i8,
}

Graph :: map[u64][dynamic]Edge


generateGraph :: proc(nodeCount: u64, minEdges: u64, maxEdges: u64) -> (Graph, bool) {
	if maxEdges >= nodeCount || maxEdges <= minEdges || nodeCount == 0 {
		return {}, false
	}

	rand.reset(nodeCount)

	G: Graph

	for nodeIdx in 0 ..< nodeCount {
		rand.reset(nodeIdx)
		edgeCount := rand.uint64_range(minEdges, maxEdges)

		edges: [dynamic]Edge

		for len(edges) < int(edgeCount) {
			to := rand.uint64_max(nodeCount)
			if to == nodeIdx do continue // no self-loops

			weight := i8(rand.int_range(-10, 10))
			append(&edges, Edge{to, weight})
		}

		G[nodeIdx] = edges
	}

	return G, true
}


printGraph :: proc(g: Graph) {
	fmt.println("\nGraph:")

	for from, edges in g {
		fmt.printfln("  Node %d (edges: %d)", from, len(edges))

		for edge, i in edges {
			fmt.printfln("    - [%d]: %d (%d)", i, edge.to, edge.weight)
		}
	}
}


main :: proc() {
	G, ok := generateGraph(10, 1, 5)
	defer delete(G)

	if ok do printGraph(G)
}
