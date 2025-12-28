package main

import "core:fmt"
import "core:math/rand"


Edge :: struct {
	from:   u64,
	to:     u64,
	weight: f32,
}

EdgesMap :: map[u64]Edge

Node :: struct {
	index: u64,
	edges: EdgesMap,
	label: string,
}

Graph :: [dynamic]Node


generateGraph :: proc(
	nodeCount: u64,
	minEdgedPerNode: u64,
	maxEdgesPerNode: u64,
) -> (
	Graph,
	bool,
) {
	if maxEdgesPerNode >= nodeCount || maxEdgesPerNode < minEdgedPerNode || nodeCount == 0 {
		return {}, false
	}

	rand.reset(nodeCount)

	G: Graph
	defer delete(G)

	for nodeIdx in 0 ..< nodeCount {
		fmt.printfln("\n[DEBUG] NodeIndex: %d", nodeIdx)
		rand.reset(nodeIdx)
		edgeCount := rand.uint64_range(minEdgedPerNode, maxEdgesPerNode)
		fmt.printfln("[DEBUG] EdgeCount: %d", edgeCount)

		edges: EdgesMap
		defer delete(edges)

		for len(edges) < int(edgeCount) {
			// rand.reset()
			to := rand.uint64_max(nodeCount)

			if to == nodeIdx do continue

			weight := rand.float32_range(-10, 10)
			edges[u64(len(edges))] = Edge{nodeIdx, to, weight}

			fmt.printfln("[DEBUG] %d -> %d", nodeIdx, to)
		}

		node := Node{nodeIdx, edges, fmt.tprintf("%d", nodeIdx)}
		append(&G, node)
	}

	return G, true
}


main :: proc() {
	fmt.println("Hello!")

	n := 200

	num := rand.int_max(n)
	num2 := rand.float32_uniform(0, 1)

	fmt.println("Number: ", num)
	fmt.println("Number2: ", num2)

	G, ok := generateGraph(10, 1, 5)

	if ok {
		for g, i in G {
			fmt.printfln("%d \t-> %d,%s: %v", i + 1, g.index, g.label, g.edges)
		}
	}


	fmt.printfln("\n\n%v", G)
}
