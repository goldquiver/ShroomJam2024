extends Node

var in_cutscene: bool = true


func is_in_cutscene() -> bool:
	return in_cutscene


func set_in_cutscene(val: bool):
	in_cutscene = val


func get_current_map() -> Node:
	var root = get_node_in_group("root")
	return root.find_child("CurrentScene").get_child(0)


func get_node_in_group(group_name: String):
	if get_tree():
		var find_node = get_tree().get_first_node_in_group(group_name)
		if find_node:
			return find_node
		return null
