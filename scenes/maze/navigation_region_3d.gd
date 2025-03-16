extends NavigationRegion3D


func shared_edge(tri1: Array, tri2: Array) -> bool:
	var common_edge: Array = []
	if tri1[0] == tri2[0] || tri1[0] == tri2[1] || tri1[0] == tri2[2]:
		common_edge.append(tri1[0])
	if tri1[1] == tri2[0] || tri1[1] == tri2[1] || tri1[1] == tri2[2]:
		common_edge.append(tri1[1])
	if tri1[2] == tri2[0] || tri1[2] == tri2[1] || tri1[2] == tri2[2]:
		common_edge.append(tri1[2])
	if len(common_edge) < 2:
		return false
	return true	
	
func average(vec: Array) -> Vector3:
	var a: Vector3 = (vec[0] + vec[1] + vec[2]) / 3
	return ceil(a * 1000) / 1000.0
	
var visited: Array = []
var leaves: Array = []
func dfs(start: Vector3) -> void:
	visited.append(start)
	if len(graph2[start]) <= 2:
		leaves.append(start)
	for neighbor: Vector3 in graph2[start]:
		if neighbor not in visited:
			visited.append(neighbor)
			dfs(neighbor)
		

var graph: Array = []
var graph2: Dictionary = {}


func _ready() -> void:
	bake_navigation_mesh(false)
	#await bake_finished
		
	var polygons: Array = []
	var vertices: Array = navigation_mesh.get_vertices()
	var vertices_array: Array = []
	
	for i in navigation_mesh.get_polygon_count():
		polygons.append(navigation_mesh.get_polygon(i))
	for polygon: PackedInt32Array in polygons:
		var arr: Array = []
		for index in polygon:
			arr.append(vertices[index])
		vertices_array.append(arr)
	var adjacency_list: Dictionary = {}
	for i in len(vertices_array):
		adjacency_list[average(vertices_array[i])] = []
		for j in range(0, len(vertices_array)):
			if shared_edge(vertices_array[i], vertices_array[j]):
				adjacency_list[average(vertices_array[i])].append(average(vertices_array[j]))
	for key: Vector3 in adjacency_list.keys():
		graph.append(to_global(key))
	var j: int = 0
	for key: Vector3 in adjacency_list.keys():
		graph2[to_global(key)] = []
		for vertex: Vector3 in adjacency_list[key]:
			graph2[to_global(key)].append(to_global(vertex))
	dfs(graph2.keys()[0])
	
