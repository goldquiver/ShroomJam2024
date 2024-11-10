extends Node

@onready var rootMapNode = $CurrentScene
@onready var saved_scenes = $SavedScenes

var trigger_data = {}


func has_trigger_data(trigger_name: String) -> bool:
	return trigger_data.has(trigger_name)


func get_trigger_data(trigger_name: String):
	if trigger_data.has(trigger_name):
		return trigger_data[trigger_name]
	return null


func set_trigger_data(trigger_name: String, new_data):
	trigger_data[trigger_name] = new_data


func change_map(map_path: String):
	# Grab new and old root nodes
	var old_map = rootMapNode.get_child(0)
	var new_map
	
	# Search for map existing in scene tree
	var filename = map_path.get_file()
	filename = filename.substr(0, filename.length() - 5)
	
	new_map = saved_scenes.get_node_or_null(filename)
	
	if new_map:
		new_map.visible = true
		new_map.reparent(rootMapNode)
		new_map.set_process_mode(PROCESS_MODE_INHERIT)
	else:
		new_map = load(map_path) as PackedScene
		var new_scene = new_map.instantiate()
		rootMapNode.add_child(new_scene)

	# Remove old map
	old_map.visible = false
	old_map.reparent(saved_scenes)
	old_map.set_process_mode(PROCESS_MODE_DISABLED)
