extends CharacterBody2D

@onready var clean_sprite = $Visuals/CleanSprite
@onready var shadow_sprite = $Visuals/ShadowSprite
@onready var glitch_anim = $Visuals/Glitch/AnimatedSprite2D

@export var current_mask_ratio:float = 200
@export var current_glitch_ratio:float = 0.75

var glitch_anim_active = false


func _process(_delta):
	shadow_sprite.modulate.a = randf() * current_mask_ratio * _delta
	set_animation_state(_delta)
	set_glitch_anim(_delta)
	
	manage_glitch_effects(_delta)


# Check whether to display the glitch or not
func manage_glitch_effects(_delta):
	glitch_anim.visible = glitch_anim_active
	glitch_anim.modulate = Color(randf()+0.2, randf()+0.2, randf()+0.2, randf()+0.2)


func set_glitch_effect(new_val: bool):
	glitch_anim_active = new_val


func set_glitch_anim(_delta):
	var curr_anim = clean_sprite.animation as String
	var root_anim_name = curr_anim
	
	if root_anim_name.ends_with("-g"):
		root_anim_name = root_anim_name.substr(0, root_anim_name.length() - 2)
	
	var curr_frame = clean_sprite.frame
	var curr_frame_progress = clean_sprite.frame_progress
	
	if randf() < current_glitch_ratio:
		clean_sprite.play(root_anim_name + "-g")
		clean_sprite.set_frame_and_progress(curr_frame, curr_frame_progress)
	else:
		clean_sprite.play(root_anim_name)
		clean_sprite.set_frame_and_progress(curr_frame, curr_frame_progress)


func set_mask_ratio(new_val: float):
	current_mask_ratio = new_val


func set_glitch_ratio(new_val: float):
	current_glitch_ratio = new_val


func set_animation_state(_delta: float):
	if not State.is_in_cutscene("Glorbo"):
		var movement_vector = Vector2.ZERO
		
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


func force_anim(anim_name: String, frame:int=0, pause_on_frame: bool=false):
	clean_sprite.play(anim_name)
	shadow_sprite.play(anim_name)
	
	clean_sprite.set_frame_and_progress(frame, 0)
	shadow_sprite.set_frame_and_progress(frame, 0)
	
	if pause_on_frame:
		clean_sprite.pause()
		shadow_sprite.pause()


func stop_anim():
	clean_sprite.set_frame_and_progress(0, 0)
	shadow_sprite.set_frame_and_progress(0, 0)
	clean_sprite.pause()
	shadow_sprite.pause()
