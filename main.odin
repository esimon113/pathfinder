package pathfinder


import "core:fmt"
import os "core:os/os2"
import "core:strconv"


Parameters :: struct {
	numNodes:           u64,
	minEdges:           u64,
	maxEdges:           u64,
	minWeight:          f32,
	maxWeight:          f32,
	withNegativeCycles: bool,
	withVerbose:        bool,
	startNodeId:        u64,
	destinationNodeId:  u64,
}


printHelp :: proc() {
	fmt.println(
		"Usage: pathfinder [OPTIONS] [NUM_NODES] [MIN_EDGES] [MAX_EDGES] [MIN_WEIGHT] [MAX_WEIGHT]",
	)
	fmt.println()
	fmt.println("Options:")
	fmt.println("  -h, --help              Show this help message")
	fmt.println("  -n, --negative-cycles   Allow negative cycles in graph generation")
	fmt.println("  -v, --verbose           Print the generated graph")
	fmt.println()
	fmt.println("Positional Arguments:")
	fmt.println("  NUM_NODES                Number of nodes in the graph (default: 100)")
	fmt.println("  MIN_EDGES                Minimum edges per node (default: 1)")
	fmt.println("  MAX_EDGES                Maximum edges per node (default: 10)")
	fmt.println("  MIN_WEIGHT               Minimum edge weight (default: -10.0)")
	fmt.println("  MAX_WEIGHT               Maximum edge weight (default: 10.0)")
	fmt.println("  START_NODE_ID            Start NodeId for the path calculation.")
	fmt.println("  DESTINATION_NODE_ID      Destination NodeId for the path calculation.")
	fmt.println()
	fmt.println("Examples:")
	fmt.println("  pathfinder")
	fmt.println("  pathfinder --help")
	fmt.println("  pathfinder 200 2 15 -5.0 5.0 0 42")
	fmt.println("  pathfinder 200 --verbose")
	fmt.println("  pathfinder 100 -n -v")
}


parseArguments :: proc() -> (Parameters, bool) {
	params := Parameters {
		numNodes           = 100,
		minEdges           = 1,
		maxEdges           = 10,
		minWeight          = -10,
		maxWeight          = 10,
		withNegativeCycles = false,
		withVerbose        = false,
		startNodeId        = 0,
		destinationNodeId  = 2,
	}

	args := os.args[1:] // ignore program name

	// Check for help flag first
	for arg in args {
		if arg == "--help" || arg == "-h" {
			return params, true
		}
	}

	if len(args) > 0 {
		if len(args) >= 1 {
			if val, ok := strconv.parse_u64(args[0]); ok {
				params.numNodes = val
			}
		}
		if len(args) >= 2 {
			if val, ok := strconv.parse_u64(args[1]); ok {
				params.minEdges = val
			}
		}
		if len(args) >= 3 {
			if val, ok := strconv.parse_u64(args[2]); ok {
				params.maxEdges = val
			}
		}
		if len(args) >= 4 {
			if val, ok := strconv.parse_f32(args[3]); ok {
				params.minWeight = val
			}
		}
		if len(args) >= 5 {
			if val, ok := strconv.parse_f32(args[4]); ok {
				params.maxWeight = val
			}
		}
		if len(args) >= 6 {
			if val, ok := strconv.parse_u64(args[5]); ok {
				params.startNodeId = val
			}
		}
		if len(args) >= 7 {
			if val, ok := strconv.parse_u64(args[6]); ok {
				params.destinationNodeId = val
			}
		}

		// Parse flags
		for arg in args {
			if arg == "--negative-cycles" || arg == "-n" {
				params.withNegativeCycles = true
			}
			if arg == "--verbose" || arg == "-v" {
				params.withVerbose = true
			}
		}
	}

	return params, false
}


// TODO: currently there is no guarantee that 'dest' is reachable from 'start'
// TODO: Make this work for graphs wiht different types
main :: proc() {
	params, showHelp := parseArguments()

	if showHelp {
		printHelp()
		return
	}

	G: Graph
	ok: bool

	if params.withNegativeCycles {
		G, ok = generateGraph(
			params.numNodes,
			params.minEdges,
			params.maxEdges,
			params.minWeight,
			params.maxWeight,
		)
	} else {
		G, ok = generateGraphNonNegativeCycles(
			params.numNodes,
			params.minEdges,
			params.maxEdges,
			params.minWeight,
			params.maxWeight,
		)
	}
	defer deleteGraph(&G)

	if !ok do return
	if params.withVerbose do printGraph(G)

	start: u64 = params.startNodeId
	dest: u64 = params.destinationNodeId

	if params.withVerbose do fmt.printfln("\nShortest path from %d to %d:", start, dest)

	pathsBFS := bfs(G, start)
	pathBFS := reconstructPath(pathsBFS, dest)
	defer {
		delete(pathsBFS)
		delete(pathBFS)
	}
	if params.withVerbose do fmt.printfln("    BFS (dist: %d): %v", len(pathBFS), pathBFS)

	if params.minWeight >= 0 {
		parentsDijk, costsDijk := dijkstra(G, start)
		pathDijk := reconstructPath(parentsDijk, dest)
		defer {
			delete(parentsDijk)
			delete(costsDijk)
			delete(pathDijk)
		}
		if params.withVerbose do fmt.printfln("    Dijkstra (cost: %f): %v", costsDijk[dest], pathDijk)
	}

	if !params.withNegativeCycles {
		parentsBF, costsBF, okBF := bellmanFord(G, start)
		defer {
			delete(parentsBF)
			delete(costsBF)
		}

		if okBF {
			pathBF := reconstructPath(parentsBF, dest)
			defer delete(pathBF)
			if params.withVerbose do fmt.printfln("    Bellman-Ford (cost: %f): %v", costsBF[dest], pathBF)
		}
	}
}
