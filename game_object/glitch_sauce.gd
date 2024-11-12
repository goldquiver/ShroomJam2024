extends Node2D


func interact():
	var root = State.get_node_in_group("root")
	root.set_trigger_data("can_glitch", true)
	queue_free()
