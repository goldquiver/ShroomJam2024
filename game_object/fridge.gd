extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D


func open_fridge():
	animated_sprite_2d.play("open")
