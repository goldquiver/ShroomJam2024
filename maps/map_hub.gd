extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var camera = $Camera2D
@onready var margin_container = $MarginContainer
@onready var disappear_ui = $MarginContainer/Disappear_UI

@export_range (0, 1) var camera_smoothing: float = 0.06

var seen_c_room_to_glitch = false

# Camera Limit list items:
# 1=top-left x, 2=top-left y, 3=bottom-right x, 4=bottom-right y
var quadrant_limits = {
	"one": [1216, -960, 2432, -160],
	"two": [0, -960, 1216, -160],
	"three": [0, -160, 1216, 640],
	"four": [1216, -160, 2432, 640]
}


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("intro")
	disappear_ui.timeout.connect(_on_ui_timer_timeout)
	randomize_endless_hall_items()


func _on_ui_timer_timeout():
	var tween = create_tween()
	tween.tween_property(margin_container, "modulate:a", 0.0, 1.0)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.chain()


func _process(_delta):
	var player = State.get_node_in_group("player")
	if player:
		var target_position_x = player.position.x
		var target_position_y = player.position.y
		set_camera_limit(player)
		camera.position.x += (target_position_x - camera.position.x) * camera_smoothing
		camera.position.y += (target_position_y - camera.position.y) * camera_smoothing


func set_camera_limit(player: CharacterBody2D):
	for i in quadrant_limits:
		var chk_quad = quadrant_limits[i]
		var top_left_bound = Vector2(chk_quad[0], chk_quad[1])
		var bottom_right_bound = Vector2(chk_quad[2], chk_quad[3])
		
		if player.global_position.x > top_left_bound.x \
			and player.global_position.x < bottom_right_bound.x \
			and player.global_position.y > top_left_bound.y \
			and player.global_position.y < bottom_right_bound.y:
			
			camera.limit_left = chk_quad[0]
			camera.limit_right = chk_quad[2]
			camera.limit_top = chk_quad[1]
			camera.limit_bottom = chk_quad[3]
			break


func triggered(trigger_name: String):
	var root = State.get_node_in_group("root")
	
	if trigger_name == "trg_glorbo_can_spawn":
		root.set_trigger_data("can_start_glorbo_cutscene", true)
		$Triggers/trg_glorbo_can_spawn.queue_free()
		
	if trigger_name == "trg_glorbo_can_spawn_2":
		root.set_trigger_data("can_start_glorbo_cutscene_2", true)
		$Triggers/trg_glorbo_can_spawn_2.queue_free()
		
	if trigger_name == "trg_start_glorbo_cutscene":
		if root.has_trigger_data("can_start_glorbo_cutscene") and root.get_trigger_data("can_start_glorbo_cutscene") == true \
			and root.has_trigger_data("can_start_glorbo_cutscene_2") and root.get_trigger_data("can_start_glorbo_cutscene_2") == true:
			$Triggers/trg_start_glorbo_cutscene.queue_free()
			$Triggers/trg_start_glorbo_cutscene_2.queue_free()
			animation_player.play("first_glorbo_cutscene")
			root.set_trigger_data("seen_glorbo_cutscene_hub", true)
	
	if trigger_name == "trg_start_glorbo_cutscene_2":
		if root.has_trigger_data("can_start_glorbo_cutscene") and root.get_trigger_data("can_start_glorbo_cutscene") == true \
			and root.has_trigger_data("can_start_glorbo_cutscene_2") and root.get_trigger_data("can_start_glorbo_cutscene_2") == true:
			$Triggers/trg_start_glorbo_cutscene.queue_free()
			$Triggers/trg_start_glorbo_cutscene_2.queue_free()
			animation_player.play("first_glorbo_cutscene_2")
			root.set_trigger_data("seen_glorbo_cutscene_hub", true)
			
	if trigger_name == "trg_endless_hall":
		var can_pass = root.get_trigger_data("seen_glitch_room_glorbo")
		if not can_pass:
			var tele_point = $Triggers/endless_hall_respawn
			State.get_node_in_group("player").position.x = tele_point.global_position.x
			randomize_endless_hall_items()

	if trigger_name == "trg_load_end_game":
		var can_pass = root.get_trigger_data("seen_glitch_room_glorbo")
		if can_pass:
			root.change_map("res://maps/map_rooftop.tscn")


func randomize_endless_hall_items():
	var hall = $walldecor/EndlessHall
	
	for kid in hall.get_children():
		kid.visible = randf() > 0.5


func check_glorbo_cutscene():
	var root = State.get_node_in_group("root")
	if not seen_c_room_to_glitch and root.get_trigger_data("seen_c_room_glorbo"):
		seen_c_room_to_glitch = true
		animation_player.play("glorbo_towards_glitch_room")
