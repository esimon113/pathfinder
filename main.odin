package pathfinder

import "core:container/priority_queue"
import "core:container/queue"
import "core:fmt"
import "core:math/rand"
import "core:slice"


Edge :: struct {
	from:   u64,
	to:     u64,
	weight: i8,
}

Graph :: map[u64][dynamic]Edge

INF64 := i64(9223372036854775807)


isInf64 :: proc(a: i64) -> bool {
	return a == INF64
}


generateGraph :: proc(
	nodeCount, minEdges, maxEdges: u64,
	minWeight, maxWeight: i8,
) -> (
	Graph,
	bool,
) {
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

			weight := i8(rand.int_range(int(minWeight), int(maxWeight)))
			append(&edges, Edge{u64(nodeIdx), to, weight})
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
// Returns a dynamic array of node ids and the cost of the path
bfs :: proc(G: Graph, start, dest: u64) -> [dynamic]u64 {
	visited := make([dynamic]bool, len(G))
	defer delete(visited)
	parent: map[u64]Maybe(u64) // maps child node id to parent node id
	defer delete(parent)
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

	return reconstructPath(parent, dest)
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


// Returns a dynamic array of node ids (path) and the cost of the path
dijkstra :: proc(G: Graph, start, dest: u64) -> ([dynamic]u64, i64) {
	costs := make([dynamic]i64, len(G))
	defer delete(costs)
	parent: map[u64]Maybe(u64)
	defer delete(parent)

	slice.fill(costs[:], INF64)

	PriorityNode :: struct {
		idx:  u64,
		cost: i64,
	}

	unvisited: priority_queue.Priority_Queue(PriorityNode)
	priority_queue.init(
		&unvisited,
		proc(a, b: PriorityNode) -> bool {return a.cost < b.cost},
		priority_queue.default_swap_proc(PriorityNode),
	)

	costs[start] = 0
	parent[start] = nil
	priority_queue.push(&unvisited, PriorityNode{start, 0})

	for priority_queue.len(unvisited) > 0 {
		current := priority_queue.pop(&unvisited)

		if current.cost > costs[current.idx] do continue
		if current.idx == dest do break

		for edge in G[current.idx] {
			newCost := costs[current.idx] + i64(edge.weight)

			if newCost < costs[edge.to] {
				costs[edge.to] = newCost
				parent[edge.to] = current.idx
				priority_queue.push(&unvisited, PriorityNode{edge.to, newCost})
			}
		}
	}

	return reconstructPath(parent, dest), costs[dest]
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


// Regards negative edge weights
// Returns a dynamic array of node ids (path) and the cost of the path
bellmanFord :: proc(G: Graph, start, dest: u64) -> ([dynamic]u64, i64) {
	costs := make([dynamic]i64, len(G))
	defer delete(costs)
	parent: map[u64]Maybe(u64)
	defer delete(parent)
	allEdges := getAllEdges(G)
	defer delete(allEdges)

	slice.fill(costs[:], INF64)
	costs[start] = 0
	parent[start] = nil


	for _ in 0 ..< len(G) - 1 {
		for edge in allEdges {
			if isInf64(costs[edge.from]) do continue

			newCost := costs[edge.from] + i64(edge.weight)
			if newCost < costs[edge.to] {
				costs[edge.to] = newCost
				parent[edge.to] = edge.from
			}
		}
	}

	for edge in allEdges {
		if !isInf64(costs[edge.from]) && !isInf64(costs[edge.to]) {
			if costs[edge.to] > costs[edge.from] + i64(edge.weight) {
				fmt.printfln("Detected negative cycle")
				return {}, 0
			}
		}
	}

	return reconstructPath(parent, dest), costs[dest]
}


// TODO: currently there is no guarantee that 'dest' is reachable from 'start'
// TODO: Make this work for graphs wiht different types
main :: proc() {
	// TODO: get parameters as command line arguments:
	numNodes: u64 = 100
	minEdges: u64 = 1
	maxEdges: u64 = 10
	minWeight: i8 = -10
	maxWeight: i8 = 10
	G, ok := generateGraph(numNodes, minEdges, maxEdges, minWeight, maxWeight)
	defer delete(G)

	if !ok do return

	// printGraph(G)
	start: u64 = 0
	dest: u64 = 2

	fmt.printfln("\nShortest path from %d to %d:", start, dest)

	pathBFS := bfs(G, start, dest)
	defer delete(pathBFS)
	fmt.printfln("    BFS (dist: %d): %v", len(pathBFS), pathBFS)

	// pathDijk, costDijk := dijkstra(G, start, dest)
	// defer delete(pathDijk)
	// fmt.printfln("    Dijkstra (cost: %d): %v", costDijk, pathDijk)

	pathBF, costBF := bellmanFord(G, start, dest)
	defer delete(pathBF)
	fmt.printfln("    Bellman-Ford (cost: %d): %v", costBF, pathBF)
}
