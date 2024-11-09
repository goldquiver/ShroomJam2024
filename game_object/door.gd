extends Node2D

@onready var door_closed = $DoorClosed
@onready var door_open = $DoorOpen

var is_open = false


func interact():
	if !is_open:
		is_open = !is_open
		# open_sound.play()

		door_open.visible = is_open
		door_closed.visible = !is_open
	else:
		get_tree().get_first_node_in_group("root").change_map("res://maps/start_screen.tscn")
