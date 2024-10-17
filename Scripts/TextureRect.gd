extends TextureRect

var path = "res://Resources/Invincible/"
func _process(delta):
	if Global.currentInvincible:
		var sauce = load(path+Global.currentInvincible+".tres")
		texture = sauce.texture
	else:
		texture = null
