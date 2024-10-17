extends TextureProgressBar

@export var stats : Player_Stats
func _ready():
	value =  (stats.Health)
	
func _process(delta):
	if stats.Health< value:
		value -= delta*250
