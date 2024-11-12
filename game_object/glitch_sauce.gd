extends Node2D


func interact():
	var root = State.get_node_in_group("root")
	root.set_trigger_data("can_glitch", true)
	
	var parent_node = get_parent()
	if parent_node.has_method("set_glitch_ratio"):
		parent_node.set_glitch_ratio(0.0)
	
	var player = State.get_node_in_group("player")
	if player.has_method("tween_glitch_icon"):
		player.tween_glitch_icon()
	
	queue_free()
