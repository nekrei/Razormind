extends RigidBody2D
var cnt = 0
var type = "fire"
func _ready():
	$bigger.disabled = true
	$extra.hide()
	$Timer.start()
	$AnimatedSprite2D.play("default")
	

func _on_timer_timeout():
	if not cnt:
		cnt += 1
		$bigger.disabled = false
		$extra.show()
		$CollisionShape2D.disabled = true
		var anim = "extra/AnimatedSprite2D"
		for i in range(8):
			var f = get_node(anim+str(i+1))
			f.play()
	else:
		call_deferred("queue_free")
