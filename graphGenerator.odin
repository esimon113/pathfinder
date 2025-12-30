package pathfinder



import "core:math/rand"



generateGraph :: proc(
	nodeCount, minEdges, maxEdges: u64,
	minWeight, maxWeight: f32,
) -> (
	Graph,
	bool,
) {
	if maxEdges >= nodeCount || maxEdges <= minEdges || nodeCount == 0 || maxWeight <= minWeight {
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

			weight := f32(rand.float32_range(minWeight, maxWeight))
			append(&edges, Edge{u64(nodeIdx), to, weight})
		}

		G[nodeIdx] = edges
	}

	return G, true
}


// Guarantees that there are no negative cycles in the graph.
// This is important for the bellmann-ford algorithm
generateGraphNonNegativeCycles :: proc(
	nodeCount, minEdges, maxEdges: u64,
	minWeight, maxWeight: f32,
) -> (
	Graph,
	bool,
) {
	if maxEdges >= nodeCount || maxEdges <= minEdges || nodeCount == 0 || maxWeight <= minWeight {
		return {}, false
	}

	rand.reset(nodeCount)

	G: Graph

	potentials := make([dynamic]f32, nodeCount)
	defer delete(potentials)

	for i in 0 ..< nodeCount {
		potentials[i] = rand.float32_range(-10, 10)
	}

	for nodeIdx in 0 ..< nodeCount {
		rand.reset(nodeIdx)
		edgeCount := rand.uint64_range(minEdges, maxEdges)

		edges: [dynamic]Edge

		for len(edges) < int(edgeCount) {
			to := rand.uint64_max(nodeCount)
			if to == nodeIdx do continue

			baseWeight := rand.float32_range(minWeight, maxWeight)
			if baseWeight < 0 do continue
			weight := baseWeight + potentials[to] - potentials[nodeIdx]

			append(&edges, Edge{u64(nodeIdx), to, weight})
		}
		G[nodeIdx] = edges
	}
	return G, true
}

