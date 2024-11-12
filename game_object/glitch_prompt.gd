extends Node2D

@onready var timer_fade_out = $Timer_fade_out
@onready var h_box_container = $HBoxContainer

func _ready():
	timer_fade_out.timeout.connect(_on_timer_timeout)


func start_timer():
	timer_fade_out.start()


func _on_timer_timeout():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(h_box_container, "modulate:a", 0.0, 0.6)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
