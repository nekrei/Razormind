extends RigidBody2D

var rot : Vector2
var speed = 620
var type = "arrow"
var is_enemy = true
func _ready():
	rotation = rot.angle()
	apply_central_impulse(speed*rot)
	$CollisionShape2D.disabled = true

func _on_arrow_h_box_area_entered(area):
	await get_tree().physics_frame
	queue_free.call_deferred()
	


func _on_timer_timeout():
	queue_free.call_deferred()


func _on_ready_timeout():
	$CollisionShape2D.disabled = false
