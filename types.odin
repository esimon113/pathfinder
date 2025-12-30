package pathfinder



Edge :: struct {
	from:   u64,
	to:     u64,
	weight: f32,
}


Graph :: map[u64][dynamic]Edge

