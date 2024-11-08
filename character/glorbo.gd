extends CharacterBody2D

@onready var wander_component = $WanderComponent
@onready var clean_sprite = $Visuals/CleanSprite
@onready var shadow_sprite = $Visuals/ShadowSprite


func _process(_delta):
	shadow_sprite.modulate.a = randf() + 0.5
	set_animation_state(_delta)


func set_animation_state(_delta: float):
	var movement_vector = wander_component.get_movement_vector()
	
	if movement_vector.x != 0:
		if movement_vector.x > 0:
			clean_sprite.play("walk-right")
			shadow_sprite.play("walk-right")
		else:
			clean_sprite.play("walk-left")
			shadow_sprite.play("walk-left")
	else:
		if movement_vector.y > 0:
			clean_sprite.play("walk-down")
			shadow_sprite.play("walk-down")
		elif movement_vector.y < 0:
			clean_sprite.play("walk-up")
			shadow_sprite.play("walk-up")
		else:
			shadow_sprite.set_frame_and_progress(0, 0)
			shadow_sprite.pause()
			clean_sprite.set_frame_and_progress(0, 0)
			clean_sprite.pause()
