extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var anim_sprite = $Visuals/AnimatedSprite2D
@onready var talkable_icon = $Visuals/TalkableIcon
@onready var interact_scanner = $InteractScanner
@onready var trigger_scanner = $TriggerScanner
@onready var glitch_prompt = $Visuals/GlitchPrompt

@onready var glitch_anim = $Visuals/Glitch/AnimatedSprite2D

var interactives_in_range = []

var current_glitch_ratio = 0.1


func _ready():
	glitch_anim.play("looping")
	
	interact_scanner.area_entered.connect(_on_interactive_area_2d_area_entered)
	interact_scanner.area_exited.connect(_on_interactive_area_2d_area_exited)
	
	trigger_scanner.area_entered.connect(_on_triggered)


func _unhandled_input(_event):
	if not State.is_in_cutscene("Shroomy"):
		if Input.is_action_just_pressed("ui_accept"):
			if interactives_in_range.size() > 0:
				var parent_object = interactives_in_range[0].get_parent() as Node2D
				if parent_object.has_method("interact"):
					parent_object.interact()


func _process(_delta):
	# Cling audio to player
	var root = State.get_node_in_group("root")
	root.track_audio_source(self)
	
	if not State.is_in_cutscene("Shroomy"):
		var movement_vector = get_movement_vector()
		var direction = movement_vector.normalized()
		
		set_animation_state(_delta)
		
		velocity_component.accelerate_in_direction(direction)
		velocity_component.move(self)
		
	if interactives_in_range.size() == 0:
		talkable_icon.modulate.a = 0
	else:
		talkable_icon.modulate.a = 1
	
	var curr_anim = anim_sprite.animation as String
	if curr_anim.begins_with("sit"):
		set_glitch_anim(_delta)
	
	manage_glitch_effects(_delta)


# Check whether to display the glitch or not
func manage_glitch_effects(_delta):
	if State.is_in_cutscene("Shroomy"):
		glitch_anim.visible = false
	else:
		var can_glitch = State.get_node_in_group("root").get_trigger_data("can_glitch")
		var glitch_on = Input.is_action_pressed("ui_glitch")
		
		glitch_anim.visible = can_glitch and glitch_on
		
		if can_glitch and glitch_on:
			State.get_node_in_group("root").play_music_spooky_glitch()
		else:
			State.get_node_in_group("root").play_music_spooky()
		
		if can_glitch:
			glitch_anim.modulate = Color(randf()+0.2, randf()+0.2, randf()+0.2, randf()+0.2)
			
			set_collision_layer_value(1, not glitch_on)
			set_collision_mask_value(1, not glitch_on)


func set_glitch_anim(_delta):
	var curr_anim = anim_sprite.animation as String
	var root_anim_name = curr_anim
	
	if root_anim_name.ends_with("-g"):
		root_anim_name = root_anim_name.substr(0, root_anim_name.length() - 2)
	
	var curr_frame = anim_sprite.frame
	var curr_frame_progress = anim_sprite.frame_progress
	
	if randf() < current_glitch_ratio:
		anim_sprite.play(root_anim_name + "-g")
		anim_sprite.set_frame_and_progress(curr_frame, curr_frame_progress)
	else:
		anim_sprite.play(root_anim_name)
		anim_sprite.set_frame_and_progress(curr_frame, curr_frame_progress)


func disable_terrain_collision():
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)


func enable_terrain_collision():
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)


func get_movement_vector():
	var x_movement = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_movement = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return Vector2(x_movement, y_movement)


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


func force_anim(anim_name: String):
	anim_sprite.play(anim_name)
	anim_sprite.set_frame_and_progress(1, 0)


func stop_anim():
	anim_sprite.set_frame_and_progress(0, 0)
	anim_sprite.pause()


func tween_talkable_icon():
	talkable_icon.position = Vector2(0, -32)
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(talkable_icon, "modulate:a", 1.0, 0.4)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(talkable_icon, "position", (talkable_icon.position + Vector2.UP * 72), 0.4)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.chain()


func tween_glitch_icon():
	glitch_prompt.visible = true
	glitch_prompt.start_timer()


# --- SIGNALIS


func _on_interactive_area_2d_area_entered(area):
	if interactives_in_range.find(area) < 0:
		interactives_in_range.append(area)
	
	if interactives_in_range.size() == 1:
		tween_talkable_icon()


func _on_interactive_area_2d_area_exited(area):
	if interactives_in_range.find(area) >= 0:
		interactives_in_range.remove_at(interactives_in_range.find(area))


func _on_triggered(area):
	var map = State.get_current_map()
	map.triggered(area.get_name())
