extends Node2D

@onready var camera = $Camera2D
@onready var anim_player = $AnimationPlayer

@export_range (0, 1) var camera_smoothing: float = 0.06

var seen_intro_cutscene = false


func _ready():
	check_glorbo_cutscene()
	$Door.open_door()


func _process(_delta):
	var target = State.get_node_in_group("player")
	if target:
		camera.position.x += (target.position.x - camera.position.x) * camera_smoothing
		camera.position.y += (target.position.y - camera.position.y) * camera_smoothing


func check_glorbo_cutscene():
	var root = State.get_node_in_group("root")
	var can_view = root.get_trigger_data("seen_glorbo_cutscene_hub")
	if can_view and not seen_intro_cutscene:
		anim_player.play("init")
		seen_intro_cutscene = true


func triggered(trigger_name: String):
	var root = State.get_node_in_group("root")
	var can_view = root.get_trigger_data("seen_glorbo_cutscene_hub")
	
	if trigger_name == "trg_make_glorbo_esped" and can_view:
		root.set_trigger_data("can_pass_endless_hall", true)
		anim_player.play("glorbo_through_wall")
		$Triggers/trg_make_glorbo_esped.queue_free()
