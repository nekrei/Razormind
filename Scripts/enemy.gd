extends CharacterBody2D
class_name Enemy2D
@export var nav_agent : NavigationAgent2D
var Player
var props =[
	[1.4, 100, 30, 1, Vector2(1,1), false, "Visuals/Sprite2D" ],
	[2, 70, 310, 2, Vector2(3,3), false, "Visuals/RangedSprite" ],
	[2.3, 70, 310, 2, Vector2(3,3), false, "Visuals/arrowsprite" ]
]
@export var type = 0
var define = "Enemy"
var target  = null
@export var max_speed = 90
var bomb_scene = preload("res://Scenes/arrow.tscn")
var arrow_scene = preload("res://Scenes/realarrow.tscn")
@onready var anim = $Visuals/Sprite2D/AnimationTree
var player_stats = preload("res://Resources/player_stats.tres")

var try :Vector2
var attackTime:= false
var Health = 100
var intended_velocity 
var dir
var is_hurt := false
var onCD := false
signal death
signal arrow_shot
signal gen_fire
func _ready():
	typecast()
	anim.active = true
	try = Vector2(586,333)
	dir = to_local(nav_agent.get_next_path_position()).normalized()		
	
	$feet.disabled = true
	$Detection/Aggro/CollisionShape2D.disabled = true
	$Detection/Aggro.monitoring = false
	nav_agent.path_desired_distance = 20
	nav_agent.target_desired_distance = 20
		
func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		if target:
			attackTime = true
		else:
			attackTime = false
		return
	else:
		attackTime = false

	intended_velocity = dir*max_speed
	nav_agent.set_velocity(intended_velocity)
	if velocity:
		if velocity.x<0:
			$Visuals.scale.x = -1
		else:
			$Visuals.scale.x = 1


func _on_nav_timer_timeout():
	if target:
		nav_agent.target_position = target.global_position
	elif not attackTime:
		nav_agent.target_position = try
	dir = to_local(nav_agent.get_next_path_position()).normalized() 


func _on_aggro_area_entered(area):
	if area.owner.name == "Player":
		target = area.owner


func _on_passive_area_exited(area):
	if area.owner == target:
		target = null


func _on_hitbox_area_entered(area):
	if area.collision_layer == 512:
		target = Player
		$feet.set_deferred("disabled",false)
		$Detection/Aggro.monitoring = true
		$Detection/Aggro/CollisionShape2D.set_deferred("disabled",false)
		nav_agent.path_desired_distance = props[type][2]
		nav_agent.target_desired_distance = props[type][2]
		
	elif area.owner.name == "Player" and area.name == "sword_hitbox":
		Health -= 35
		is_hurt = true
	elif area.owner is RigidBody2D:
		if area.owner.type == "arrow" and not area.owner.is_enemy:
			Health -= 25
			is_hurt = true
	if Health <= 0:
		death.emit(global_position)
		Health = 0
		call_deferred("queue_free")


func _on_melee_hitbox_area_entered(area):
	if area.owner.name == "Player":
		if Global.currentInvincible == "melee":
			area.owner.set("Label/Text","Invincible!")
			var q = area.owner.get_node("Label/Timer")
			q.start()
		else:
			player_stats.Health -= 10
			area.owner.is_hurt = true
		if player_stats.Health < 0:
			player_stats.Health = 0


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	if velocity:
		if velocity.x<0:
			$Visuals.scale.x = -1
		else:
			$Visuals.scale.x = 1
	move_and_slide()


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "hurt":
		is_hurt = false
	if anim_name == "walk" and type == 0:
		$AttackCD.start()
		onCD = true
	if anim_name == "bomb_attack" or anim_name == "melee_attack" or anim_name == "arrow_attack":
		$AttackCD.start()
		onCD = true
	if anim_name == "arrow_attack":
		arrow_shot.emit(position,target.position)

func bomb_thrown()->void:
	var ini := position
	var final = target.position
	var bomb = bomb_scene.instantiate()
	var vctr = (final-ini)
	bomb.rot = vctr.normalized()
	bomb.speed = vctr.length()
	bomb.isFire = (Global.Wave - 1)*0.2 > randf()
	bomb.fire.connect(on_fire)
	add_child(bomb)

func _on_attack_cd_timeout():
	onCD = false
	


func _on_animation_tree_animation_started(anim_name):
	if anim_name == "arrow_attack":
		if (target.position - position).x < 0:
			$Visuals.scale.x = -1
		else:
			$Visuals.scale.x = 1

func on_fire(pos):
	#print("yooo")
	gen_fire.emit(pos)

func typecast():
	$Visuals/RangedSprite.hide()
	$Visuals/Sprite2D.hide()
	$Visuals/arrowsprite.hide()
	
	$AttackCD.wait_time = props[type][0]
	$NavigationAgent2D.max_speed = props[type][1]
	nav_agent.path_desired_distance = props[type][2]
	nav_agent.target_desired_distance = props[type][2]
	$NavigationAgent2D.set("avoidance_mask",props[type][3])
	$Detection/Passive.monitoring = props[type][5]
	$Detection/Aggro.scale = props[type][4]
	var my_sprite = get_node(props[type][6])
	my_sprite.show()
