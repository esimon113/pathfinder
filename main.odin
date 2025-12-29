package main

import "core:container/queue"
import "core:fmt"
import "core:math/rand"
import "core:slice"


Edge :: struct {
	to:     u64,
	weight: u8,
}

Graph :: map[u64][dynamic]Edge


generateGraph :: proc(nodeCount, minEdges, maxEdges: u64, maxWeight: u8) -> (Graph, bool) {
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

			weight := u8(rand.int_max(int(maxWeight)))
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


// ignore weights with BFS
// Returns a dynamic array of node ids
bfs :: proc(G: Graph, start, dest: u64) -> [dynamic]u64 {
	visited := make([dynamic]bool, len(G))
	parent: map[u64]Maybe(u64) // maps child node id to parent node id
	for g in G do visited[g] = false

	pending: queue.Queue(u64)
	queue.init(&pending)
	queue.enqueue(&pending, start)

	visited[start] = true
	parent[start] = nil

	for queue.len(pending) > 0 {
		idx := queue.dequeue(&pending)

		if idx == dest do break

		for edge in G[idx] {
			if !visited[edge.to] {
				queue.enqueue(&pending, edge.to)
				visited[edge.to] = true
				parent[edge.to] = idx
			}
		}
	}

	// reconstruct path
	path: [dynamic]u64
	current: Maybe(u64) = dest

	for current != nil {
		append(&path, current.?)
		current = parent[current.?]
	}

	slice.reverse(path[:])
	return path
}


main :: proc() {
	numNodes: u64 = 10
	minEdges: u64 = 1
	maxEdges: u64 = 5
	maxWeight: u8 = 10
	G, ok := generateGraph(numNodes, minEdges, maxEdges, maxWeight)
	defer delete(G)

	if !ok do return

	printGraph(G)
	start: u64 = 0
	dest: u64 = 2
	path := bfs(G, start, dest)
	defer delete(path)

	fmt.printfln("\nShortest path from %d to %d: %v", start, dest, path)
}
