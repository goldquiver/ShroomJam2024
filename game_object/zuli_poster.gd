extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	animated_sprite_2d.set_frame_and_progress(0, 0)

func interact():
	animated_sprite_2d.play("default")
