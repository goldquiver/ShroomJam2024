extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D


func interact():
	animated_sprite_2d.play("default")
