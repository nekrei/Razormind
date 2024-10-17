extends RigidBody2D

var rot : Vector2
var rotangle : float
var cf : Vector2
var speed : float
var isFire = false
var type := "bomb"
signal fire

func _ready():
	$CollisionShape2D.disabled = true
	hide()
	apply_central_impulse(speed*rot)
	if rot.x<0:
		rotangle = rot.angle()-PI/2
	else:
		rotangle = rot.angle()+PI/2
	cf = 450*Vector2.from_angle(rotangle)
	add_constant_central_force(cf)
	apply_central_impulse(-0.5*cf)

func _on_timer_timeout():
	if isFire:
		fire.emit(global_position)
	call_deferred("queue_free")

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.velocity = linear_velocity.normalized()*200
		if body.define == "Enemy":
			body.velocity = linear_velocity.normalized()*400
	if isFire:
		fire.emit(global_position)
	queue_free.call_deferred()


func _on_ready_timeout():
	$CollisionShape2D.disabled = false
	$Sprite2D.frame = isFire
	show()
