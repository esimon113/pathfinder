package pathfinder

import "core:container/priority_queue"
import "core:container/queue"
import "core:fmt"
import "core:math"
import "core:slice"


// ignore weights with BFS
// Returns a map of parent node ids: map[childId]=parentId
// To get the shortest path to dst, "reconstructPath(parent, dest)" can be used
bfs :: proc(G: Graph, start: u64) -> map[u64]Maybe(u64) {
	visited := make([dynamic]bool, len(G))
	parent: map[u64]Maybe(u64) // maps child node id to parent node id
	defer {
		delete(visited)
		// delete(parent)
	}
	for g in G do visited[g] = false

	pending: queue.Queue(u64)
	queue.init(&pending)
	defer queue.destroy(&pending)
	queue.enqueue(&pending, start)

	visited[start] = true
	parent[start] = nil

	for queue.len(pending) > 0 {
		idx := queue.dequeue(&pending)

		for edge in G[idx] {
			if !visited[edge.to] {
				queue.enqueue(&pending, edge.to)
				visited[edge.to] = true
				parent[edge.to] = idx
			}
		}
	}

	return parent
}


// Returns a map of parent node ids: "map[childId]=parentId" and a dynamic array of costs
// To get the shortest path to dst, "reconstructPath(parent, dest)" can be used
dijkstra :: proc(G: Graph, start: u64) -> (map[u64]Maybe(u64), [dynamic]f32) {
	costs := make([dynamic]f32, len(G))
	parent: map[u64]Maybe(u64)
	// defer {
	// 	delete(costs)
	// 	delete(parent)
	// }

	slice.fill(costs[:], math.INF_F32)

	PriorityNode :: struct {
		idx:  u64,
		cost: f32,
	}

	unvisited: priority_queue.Priority_Queue(PriorityNode)
	priority_queue.init(
		&unvisited,
		proc(a, b: PriorityNode) -> bool {return a.cost < b.cost},
		priority_queue.default_swap_proc(PriorityNode),
	)
	defer priority_queue.destroy(&unvisited)

	costs[start] = 0
	parent[start] = nil
	priority_queue.push(&unvisited, PriorityNode{start, 0})

	for priority_queue.len(unvisited) > 0 {
		current := priority_queue.pop(&unvisited)

		if current.cost > costs[current.idx] do continue

		for edge in G[current.idx] {
			newCost := costs[current.idx] + edge.weight

			if newCost < costs[edge.to] {
				costs[edge.to] = newCost
				parent[edge.to] = current.idx
				priority_queue.push(&unvisited, PriorityNode{edge.to, newCost})
			}
		}
	}

	return parent, costs
}


// Regards negative edge weights
// Returns a map of parent node ids: "map[childId]=parentId", and a dynamic array of costs, and a success indication
// To get the shortest path to dst, "reconstructPath(parent, dest)" can be used
bellmanFord :: proc(G: Graph, start: u64) -> (map[u64]Maybe(u64), [dynamic]f32, bool) {
	costs := make([dynamic]f32, len(G))
	parent: map[u64]Maybe(u64)
	allEdges := getAllEdges(G)
	defer delete(allEdges)

	slice.fill(costs[:], math.INF_F32)
	costs[start] = 0
	parent[start] = nil


	for _ in 0 ..< len(G) - 1 {
		for edge in allEdges {
			if math.is_inf_f32(costs[edge.from]) do continue

			newCost := costs[edge.from] + edge.weight
			if newCost < costs[edge.to] {
				costs[edge.to] = newCost
				parent[edge.to] = edge.from
			}
		}
	}

	for edge in allEdges {
		if !math.is_inf_f32(costs[edge.from]) {
			if costs[edge.to] > costs[edge.from] + edge.weight {
				fmt.printfln("Detected negative cycle")
				delete(costs)
				delete(parent)
				return {}, {}, false
			}
		}
	}

	return parent, costs, true
}
