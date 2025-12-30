package pathfinder

import "core:container/priority_queue"
import "core:container/queue"
import "core:fmt"
import "core:math"
import "core:slice"



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


// Returns a dynamic array of node ids (path) and the cost of the path
dijkstra :: proc(G: Graph, start, dest: u64) -> ([dynamic]u64, f32) {
	costs := make([dynamic]f32, len(G))
	defer delete(costs)
	parent: map[u64]Maybe(u64)
	defer delete(parent)

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

	costs[start] = 0
	parent[start] = nil
	priority_queue.push(&unvisited, PriorityNode{start, 0})

	for priority_queue.len(unvisited) > 0 {
		current := priority_queue.pop(&unvisited)

		if current.cost > costs[current.idx] do continue
		if current.idx == dest do break

		for edge in G[current.idx] {
			newCost := costs[current.idx] + edge.weight

			if newCost < costs[edge.to] {
				costs[edge.to] = newCost
				parent[edge.to] = current.idx
				priority_queue.push(&unvisited, PriorityNode{edge.to, newCost})
			}
		}
	}

	return reconstructPath(parent, dest), costs[dest]
}


// Regards negative edge weights
// Returns a dynamic array of node ids (path) and the cost of the path
bellmanFord :: proc(G: Graph, start, dest: u64) -> ([dynamic]u64, f32) {
	costs := make([dynamic]f32, len(G))
	defer delete(costs)
	parent: map[u64]Maybe(u64)
	defer delete(parent)
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
				return {}, 0
			}
		}
	}

	return reconstructPath(parent, dest), costs[dest]
}

