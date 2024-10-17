extends CharacterBody2D
class_name MainChar

@export var max_speed = 150
var define = "Player"
var stats = preload("res://Resources/player_stats.tres")
var arrow_scene = preload("res://Scenes/realarrow.tscn")

var accel = 650
var decel = 1150
var play_attack
var is_hurt := false
var arrowrot : Vector2
var equipt = 1
var inv_access = ["inv_1", "inv_2", "inv_3", "inv_4"]
var weight = 1
signal update_inv
var can_invincible := true
@export var inv : Inventory
@onready var anim = $visuals/Sprite2D/AnimationTree
func _ready():
	anim.active = true
	$Label.text = ""
	
func _physics_process(delta):
	var inp = Input.get_vector("left","right","up","down")
	if Input.is_action_just_pressed("switch"):
		equipt = -equipt
	if inp:
		velocity = velocity.move_toward(max_speed*inp, delta*accel)
	else:
		velocity = velocity.move_toward(Vector2(0,0), delta*decel)
	velocity = weight*velocity
	anim.set("parameters/Comp/movement/walk/blend_position", inp)
	anim.set("parameters/Comp/movement/bow_walk/blend_position", inp)
	play_attack = Input.is_action_pressed("p1_attack")
	
	if weight != 1:
		$IndicatorArrow.show()
		arrowrot = (get_global_mouse_position() - position)
		$IndicatorArrow.rotation = arrowrot.angle()
		if arrowrot.x < 0:
			$visuals.scale.x  = -1
		else:
			$visuals.scale.x  = 1
	else:
		$IndicatorArrow.hide()
	
	flip.call_deferred()
	for pressed in inv_access:
		if Input.is_action_pressed(pressed):
			edit_inv(pressed)
			break
	move_and_slide()

func flip():
	if velocity:
		if velocity.x<0:
			$visuals.scale.x = -1		
		else:
			$visuals.scale.x = 1


func _on_test_coll_item(item_node):
	$itempicked.play()
	var item_res = item_node.res
	for i in range(inv.has.size()):
		if not inv.has[i]:
			inv.has[i] = item_res
			break
	update_inv.emit()
	
func edit_inv(pressed:String):
	if not can_invincible:
		return
	$equip.play()
	var x = int(pressed[4])
	if inv.has[x-1]:
		$InvincibleTimer.start()
		can_invincible = false
		Global.currentInvincible = inv.has[x-1].name
	inv.has[x-1] = null
	update_inv.emit()
			

func _on_hitbox_body_entered(body):
	if body is RigidBody2D:
		if body.collision_layer == 16:
			if body.type == Global.currentInvincible:
				$Label.text = "Invincible!"
				$Label/Timer.start()
			else:
				if body.type == "fire":
					stats.Health -= 2
				else:
					stats.Health -= 10
				is_hurt = true
			if stats.Health < 0:
				stats.Health = 0


func _on_invincible_timer_timeout():
	Global.currentInvincible = ""
	can_invincible = true


func _on_animation_tree_animation_started(anim_name):
	if anim_name == "hurt" or anim_name == "bow_hurt":
		weight = 1
	if anim_name == "bow" or anim_name == "bow_shot":
		weight = 0.5
	if anim_name == "bow_shot":
		var arrow = arrow_scene.instantiate()
		arrow.rot = arrowrot.normalized()
		arrow.is_enemy = false
		add_child(arrow)

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "bow_shot":
		weight = 1
	if anim_name == "hurt" or anim_name == "bow_hurt":
		is_hurt = false


func _on_main_coll_item(item_node):
	var ter := true
	$itempicked.play()
	var item_res = item_node.res
	for i in range(inv.has.size()):
		if not inv.has[i]:
			inv.has[i] = item_res
			ter = false
			break
	if ter:
		$Label.text = "Inventory Full"
		$Label/Timer.start()
	update_inv.emit()


func _on_timer_timeout():
		$Label.text = ""
