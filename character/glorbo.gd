extends CharacterBody2D

@onready var wander_component = $WanderComponent
@onready var clean_sprite = $Visuals/CleanSprite
@onready var shadow_sprite = $Visuals/ShadowSprite

var is_wandering = false


func _process(_delta):
	shadow_sprite.modulate.a = randf() + 0.5
	set_animation_state(_delta)


func set_animation_state(_delta: float):
	if not State.is_in_cutscene("Glorbo"):
		wander_component.active = is_wandering
		var movement_vector
		if is_wandering:
			movement_vector = wander_component.get_movement_vector()
		else:
			movement_vector = Vector2.ZERO
		
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


func force_anim(anim_name: String):
	clean_sprite.play(anim_name)
	shadow_sprite.play(anim_name)


func stop_anim():
	clean_sprite.set_frame_and_progress(0, 0)
	shadow_sprite.set_frame_and_progress(0, 0)
	clean_sprite.pause()
	shadow_sprite.pause()
