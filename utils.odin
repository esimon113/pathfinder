package pathfinder

import "core:fmt"
import "core:slice"


printGraph :: proc(g: Graph) {
	fmt.println("\nGraph:")

	for from, edges in g {
		fmt.printfln("  Node %d (edges: %d)", from, len(edges))

		for edge, i in edges {
			fmt.printfln("    - [%d]: %d (%.2f)", i, edge.to, edge.weight)
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


reconstructPathForPair :: proc(
	parents: [dynamic][dynamic]Maybe(u64),
	u, v: u64,
) -> (
	[dynamic]u64,
	bool,
) {
	path: [dynamic]u64
	v := v
	u := u

	if parents[u][v] == nil do return {}, false

	append(&path, v)

	for u != v {
		v = parents[u][v].?
		append(&path, v)
	}

	slice.reverse(path[:])

	return path, true
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


// Returns the Edge (fromNodeId->toNodeId) if it exists and a success indicator
getEdge :: proc(G: Graph, from, to: u64) -> (Edge, bool) {
	allEdges := getAllEdges(G)
	defer delete(allEdges)

	for e in allEdges {
		if e.from == from && e.to == to {
			return e, true
		}
	}
	return {}, false
}


// Properly deletes a Graph by first deleting all nested dynamic arrays
deleteGraph :: proc(G: ^Graph) {
	for _, edges in G^ {
		delete(edges)
	}
	delete(G^)
}
