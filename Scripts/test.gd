extends Node2D

signal coll_item
@export var collectibles : PackedScene
@export var enemies : PackedScene
@export var arrow_scene : PackedScene
var boulder_scene = preload("res://Scenes/boulder.tscn")
var fire_scene = preload("res://Scenes/fire.tscn")
func _ready():
	Global.loadColl()
	
func _on_collectible_spawn_timeout():	
	var enemy = enemies.instantiate()
	enemy.position = Vector2(randf()*1152, randf()*648)
	enemy.type = randi()%3
	enemy.death.connect(on_enemy_death)
	enemy.arrow_shot.connect(on_arrow_shot)
	enemy.gen_fire.connect(on_ffire)
	add_child(enemy)
	
func on_item_collected(item_node):
	coll_item.emit(item_node)
	
func on_enemy_death():
	var item = collectibles.instantiate()
	item.position = Vector2(randf()*1152, randf()*648)
	item.collected.connect(on_item_collected)
	add_child.call_deferred(item)

func on_arrow_shot(ini: Vector2, final: Vector2):
	var arrow = arrow_scene.instantiate()
	arrow.position = ini
	arrow.rot = (final-ini).normalized()
	add_child(arrow)


func _on_boulder_spawn_timeout():
	var boulder = boulder_scene.instantiate()
	boulder.position.y = 30
	boulder.position.x = randf()*1152
	add_child(boulder)

func on_ffire(pos):
	#print("yo")
	var fire = fire_scene.instantiate()
	fire.position = to_local(pos)
	call_deferred("add_child",fire)
