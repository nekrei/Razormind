extends Area2D
class_name Collectible

@export var sprite : Sprite2D
var present := 0
var res 
signal collected 
var inv = preload("res://Resources/DummyInv.tres")

func _ready():
	res = Global.collectible[randi()%Global.collectible.size()]
	sprite.texture = res.texture

func _process(delta):
	if Input.is_action_pressed("interact"):
		if present > 0:
			var ter := true
			for i in range(inv.has.size()):
				if not inv.has[i]:
					ter = false
					break
			collected.emit(self)
			if not ter:
				queue_free.call_deferred()

func _on_area_entered(area):
	#print(area.owner.name)
	if area.owner:
		if area.owner.name == "Player":
			present+=1


func _on_area_exited(area):
	#print(area.owner.name)
	if area.owner:
		if area.owner.name == "Player":
			present -=1
