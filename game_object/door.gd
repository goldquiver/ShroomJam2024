extends Node2D

@onready var door_closed = $DoorClosed
@onready var door_open = $DoorOpen

var is_open = false


func open_door():
	is_open = true
	door_open.visible = is_open
	door_closed.visible = !is_open


func close_door():
	is_open = false
	door_open.visible = is_open
	door_closed.visible = !is_open


func interact():
	if !is_open:
		open_door()
	else:
		get_tree().get_first_node_in_group("root").change_map("res://maps/start_screen.tscn")
