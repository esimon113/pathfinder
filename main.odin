package pathfinder


import "core:fmt"




// TODO: currently there is no guarantee that 'dest' is reachable from 'start'
// TODO: Make this work for graphs wiht different types
main :: proc() {
	// TODO: get parameters as command line arguments:
	numNodes: u64 = 100
	minEdges: u64 = 1
	maxEdges: u64 = 10
	minWeight: f32 = -10
	maxWeight: f32 = 10
	withNegativeCycles: bool = false

	G: Graph
	ok: bool

	if withNegativeCycles {
		G, ok = generateGraph(numNodes, minEdges, maxEdges, minWeight, maxWeight)
	} else {
		G, ok = generateGraphNonNegativeCycles(numNodes, minEdges, maxEdges, minWeight, maxWeight)
	}
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
	// fmt.printfln("    Dijkstra (cost: %f): %v", costDijk, pathDijk)

	pathBF, costBF := bellmanFord(G, start, dest)
	defer delete(pathBF)
	fmt.printfln("    Bellman-Ford (cost: %f): %v", costBF, pathBF)
}
