package pathfinder

import "core:fmt"
import "core:slice"



printGraph :: proc(g: Graph) {
	fmt.println("\nGraph:")

	for from, edges in g {
		fmt.printfln("  Node %d (edges: %d)", from, len(edges))

		for edge, i in edges {
			fmt.printfln("    - [%d]: %d (%d)", i, edge.to, edge.weight)
		}
	}
}


reconstructPath :: proc(parent: map[u64]Maybe(u64), dest: u64) -> [dynamic]u64 {
	path: [dynamic]u64
	current: Maybe(u64) = dest

	for current != nil {
		append(&path, current.?)
		current = parent[current.?]
	}

	slice.reverse(path[:])

	return path
}


getAllEdges :: proc(G: Graph) -> [dynamic]Edge {
	edges: [dynamic]Edge

	for nodeIdx in 0 ..< len(G) {
		for edge in G[u64(nodeIdx)] {
			if !slice.contains(edges[:], edge) {
				append(&edges, edge)
			}
		}
	}
	return edges
}

