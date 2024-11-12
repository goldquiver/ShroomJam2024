extends Node2D



#func _process(_delta):
	#if Input.is_action_just_pressed("ui_accept"):
		#var root = State.get_node_in_group("root") as Node
		#var saved_list = root.find_child("SavedScenes")
		#
		## Reset data to restart
		#for i in saved_list.get_children():
			#saved_list.remove_child(i)
		#
		#root.trigger_data = {}
		#
		#root.change_map("res://maps/start_screen.tscn")
