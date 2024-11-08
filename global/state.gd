extends Node

var player_control: bool = false


func get_player_control() -> bool:
	return player_control


func set_player_control(val: bool):
	player_control = val


func get_node_in_group(group_name: String):
	if get_tree():
		var find_node = get_tree().get_first_node_in_group(group_name)
		if find_node:
			return find_node
		return null
