extends Node2D

signal coll_item
@export var collectibles : PackedScene
@export var enemies : PackedScene
@export var arrow_scene : PackedScene
var boulder_scene = preload("res://Scenes/boulder.tscn")
var fire_scene = preload("res://Scenes/fire.tscn")
var boss_scene = preload("res://Scenes/boss.tscn")
@onready var player = $Player
var subWaves = 1
var Mcount = 0
var Rcount = 0
var Acount = 0
var totalEnemy: Array =[0,2,4,5,6,6]
var firstTime := true
func _ready():
	Global.loadColl()
	
func _process(delta):
	if firstTime:
		if Input.is_anything_pressed():
			$CanvasLayer.hide()
			_on_timer_timeout()
			$Timer.start()
			firstTime = false
				
func _on_timer_timeout():
	Mcount = Wavelogic.count[subWaves][0]
	Rcount = Wavelogic.count[subWaves][1]
	Acount = Wavelogic.count[subWaves][2]
	var x = "SpawnMarkers/Marker2D"
	for i in range(totalEnemy[Global.Wave]):
		var h
		if i < 3:
			h = randi()%2 + i*2
		else:
			h = i+3
		var gate = get_node(x+str(h))
		var enemy = enemies.instantiate()
		enemy.Player = player
		enemy.position = gate.position
		if Mcount:
			enemy.type = 0
			Mcount -= 1
		elif Rcount:
			enemy.type = 1
			Rcount -= 1
		else:
			enemy.type = 2
			Acount -= 1
		enemy.death.connect(on_enemy_death)
		enemy.arrow_shot.connect(on_arrow_shot)
		enemy.gen_fire.connect(on_ffire)
		add_child(enemy)
	print(subWaves)
	subWaves += 1
	if subWaves >= 25:
		$Timer.stop()
	if subWaves%5 == 0:
		Global.Wave += 1
		if Global.Wave >= 3:
			#$bould.start()
			pass
				
	
func on_enemy_death(posit):
	var item = collectibles.instantiate()
	item.position = to_local(posit)
	item.collected.connect(on_item_collected)
	add_child.call_deferred(item)

func on_arrow_shot(ini: Vector2, final: Vector2):
	var arrow = arrow_scene.instantiate()
	arrow.position = ini
	arrow.rot = (final-ini).normalized()
	add_child(arrow)


func on_ffire(pos):
	#print("yo")
	var fire = fire_scene.instantiate()
	fire.position = to_local(pos)
	call_deferred("add_child",fire)



func _on_bould_timeout():
	var boulder = boulder_scene.instantiate()
	boulder.position.y = 90
	boulder.position.x = 130 + (1000-130)*randf()
	add_child(boulder)

func on_item_collected(item_node):
	coll_item.emit(item_node)
