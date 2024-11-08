extends Node

@onready var rootMapNode = $CurrentScene


func change_map(map_path: String):
	# Grab new and old root nodes
	var old_map = rootMapNode.get_child(0)
	var new_map = load(map_path) as PackedScene
	
	# Instantiate new map
	var new_scene = new_map.instantiate()
	rootMapNode.add_child(new_scene)
	
	# Remove old map
	old_map.queue_free()
