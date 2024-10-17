extends TextureProgressBar
@export var entity : CharacterBody2D

func _process(delta):
	value = entity.Health
