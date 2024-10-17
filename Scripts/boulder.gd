extends RigidBody2D
var type = "boulder"
var rot
func _ready():
	var x = (0.5 - randf())*2
	$AnimatedSprite2D.flip_h = x < 0 
	var y = randf()
	rot = Vector2(x,y).normalized()
	apply_central_impulse(250*rot)
	$AnimatedSprite2D.play("default")

func _on_body_entered(body):
	apply_central_impulse(200*rot)
	if body is CharacterBody2D:
		var diff = body.position - position
		var vldiff = diff - linear_velocity
		if vldiff.angle() <= PI/2 and vldiff.angle() >= -(PI/2):
			body.velocity = 300*diff.normalized()
	$CollisionShape2D.set_deferred("disabled",true)
	$disabledTIme.start()
	
func _on_timer_timeout():
	call_deferred("queue_free")


func _on_disabled_t_ime_timeout():
	$CollisionShape2D.set_deferred("disabled",false)
