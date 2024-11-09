extends Node

@export var velocity_component: Node
@export var active: bool = true
@export var wander_radius: int = 200
@export var min_rand_time = 1
@export var max_rand_time = 8

@onready var timer = $Timer

var ROOT_POSITION: Vector2
var target_position: Vector2


func _ready():
	ROOT_POSITION = get_parent().global_position
	target_position = ROOT_POSITION
	timer.timeout.connect(_on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if active:
		var movement_vector = get_movement_vector()
		var direction = movement_vector.normalized()
		velocity_component.accelerate_in_direction(direction)
		velocity_component.move(velocity_component.get_parent())


func get_movement_vector():
	var parent_pos = get_parent().global_position
	if (parent_pos.distance_to(target_position) > 5):
		return Vector2(\
			target_position.x - parent_pos.x,\
			target_position.y - parent_pos.y)
	else:
		return Vector2.ZERO


func _on_timer_timeout():
	target_position = Vector2(\
		ROOT_POSITION.x + randf_range(-1, 1)*wander_radius,\
		ROOT_POSITION.y + randf_range(-1, 1)*wander_radius)
	
	timer.wait_time = randf_range(min_rand_time, max_rand_time)
	timer.start()
