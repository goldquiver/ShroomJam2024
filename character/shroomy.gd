extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var anim_sprite = $Visuals/AnimatedSprite2D
@onready var talkable_icon = $Visuals/TalkableIcon
@onready var interact_scanner = $InteractScanner

var interactives_in_range = []


func _ready():
	interact_scanner.area_entered.connect(_on_interactive_area_2d_area_entered)
	interact_scanner.area_exited.connect(_on_interactive_area_2d_area_exited)


func _process(_delta):
	if State.get_player_control():
		var movement_vector = get_movement_vector()
		var direction = movement_vector.normalized()
		
		set_animation_state(_delta)
		velocity_component.max_speed = 600 if Input.is_action_pressed("ui_run") else 400
		
		velocity_component.accelerate_in_direction(direction)
		velocity_component.move(self)


func set_input_control(control: bool):
	State.set_player_control(control)


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


func stop_anim():
	anim_sprite.set_frame_and_progress(0, 0)
	anim_sprite.pause()


func tween_talkable_icon():
	talkable_icon.position = Vector2(0, -64)
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(talkable_icon, "modulate:a", 1.0, 0.4)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(talkable_icon, "position", (talkable_icon.position + Vector2.UP * 72), 0.4)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.chain()


# --- SIGNALIS


func _on_interactive_area_2d_area_entered(area):
	if interactives_in_range.find(area) < 0:
		interactives_in_range.append(area)
	
	if interactives_in_range.size() == 1:
		tween_talkable_icon()


func _on_interactive_area_2d_area_exited(area):
	if interactives_in_range.find(area) >= 0:
		interactives_in_range.remove_at(interactives_in_range.find(area))
