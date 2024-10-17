extends TextureProgressBar

func  _ready():
	max_value = 11
	value = 11
func _process(delta):
	if Global.currentInvincible != "":
		show()
		value -= delta
	else:
		value = 11
		hide()
