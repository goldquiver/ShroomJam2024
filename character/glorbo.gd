extends CharacterBody2D

@onready var wander_component = $WanderComponent
@onready var anim_sprite = $Visuals/AnimatedSprite2D


func _process(_delta):
	set_animation_state(_delta)


func set_animation_state(_delta: float):
	var movement_vector = wander_component.get_movement_vector()
	
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
