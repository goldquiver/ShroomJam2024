extends Node

var in_cutscene = {
	"Shroomy": true,
	"Glorbo": true,
}


func is_in_cutscene(char_name: String) -> bool:
	return in_cutscene[char_name]


func set_in_cutscene(char_name: String, val: bool):
	in_cutscene[char_name] = val


func set_all_in_cutscene(val: bool):
	for i in in_cutscene:
		in_cutscene[i] = val


func get_current_map() -> Node:
	var root = get_node_in_group("root")
	return root.find_child("CurrentScene").get_child(0)


func get_node_in_group(group_name: String):
	var curr_tree
	
	var tree_root = get_parent()
	for kid in tree_root.get_children():
		if kid.name == "Root":
			for grandkid in kid.get_children():
				if grandkid.name == "CurrentScene":
					curr_tree = grandkid
					break
	
	if curr_tree:
		var find_node = curr_tree.get_tree().get_first_node_in_group(group_name)
		if find_node:
			return find_node
		return null
