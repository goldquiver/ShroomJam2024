extends Node

@onready var rootMapNode = $CurrentScene
@onready var saved_scenes = $SavedScenes


func change_map(map_path: String):
	# Grab new and old root nodes
	var old_map = rootMapNode.get_child(0)
	var new_map
	
	# Search for map existing in scene tree
	var filename = map_path.get_file()
	filename = filename.substr(0, filename.length() - 5)
	
	new_map = saved_scenes.get_node(filename)
	
	if new_map:
		new_map.set_process_mode(PROCESS_MODE_INHERIT)
		new_map.reparent(rootMapNode)
		new_map.visible = true
	else:
		new_map = load(map_path) as PackedScene
		var new_scene = new_map.instantiate()
		rootMapNode.add_child(new_scene)

	# Remove old map
	old_map.set_process_mode(PROCESS_MODE_DISABLED)
	old_map.visible = false
	old_map.reparent(saved_scenes)
