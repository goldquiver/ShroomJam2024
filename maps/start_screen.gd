extends Node2D

@onready var start_button = $VBoxContainer/StartButton
@onready var exit_button = $VBoxContainer/ExitButton
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

var selected_button = 1


func _ready():
	animation_player.play("idle")
	audio_stream_player_2d.play()


func _process(_delta):
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		if selected_button == 1:
			selected_button = 2
		else:
			selected_button = 1
		animation_player.stop()
		animation_player.play("idle")
	
	if selected_button == 1:
		sprite_2d.offset.y = 0
	else:
		sprite_2d.offset.y = 56
		
	if Input.is_action_just_pressed("ui_accept"):
		var root = State.get_node_in_group("root")
		if selected_button == 1:
			# Start the game!
			root.change_map("res://maps/map_hub.tscn")
		else:
			# End the game!
			get_tree().quit()

	# Quit on escape on start streen
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_start_button_mouse_entered():
	selected_button = 1


func _on_exit_button_mouse_entered():
	selected_button = 2


func _on_start_button_button_up():
	var root = State.get_node_in_group("root")
	root.change_map("res://maps/map_hub.tscn")


func _on_exit_button_button_up():
	get_tree().quit()
