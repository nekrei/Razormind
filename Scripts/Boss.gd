extends Node2D

func _ready():
	$Enemy.scale = Vector2(2,2)
	$Enemy.Health = 280

func _on_timer_timeout():
	$Enemy.type = randi()%3
	$Enemy.call_deferred("typecast")
	
