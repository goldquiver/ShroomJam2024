extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var anim_sprite = $Visuals/AnimatedSprite2D

var target_position


func _ready():
	target_position = global_position


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		target_position.y = target_position.y - 100

	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	
	set_animation_state(_delta)
	
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)


func get_movement_vector():
	if (global_position.distance_to(target_position) > 5):
		print(global_position)
		print(target_position)
		return Vector2(\
			target_position.x - global_position.x,\
			target_position.y - global_position.y)
	else:
		target_position = global_position
		return Vector2.ZERO


func set_animation_state(_delta: float):
	var movement_vector = get_movement_vector()
	
	if movement_vector.x != 0:
		if movement_vector.x > 0:
			anim_sprite.play("walk-right")
		else:
			anim_sprite.play("walk-left")
	else:
		if movement_vector.y > 0:
			anim_sprite.play("walk-down")
		elif movement_vector.y < 0:
			anim_sprite.play("walk-up")
		else:
			anim_sprite.set_frame_and_progress(0, 0)
			anim_sprite.pause()
