extends TextureProgressBar

var intend = 100
func _ready():
	value = intend
	
func _process(delta):
	if intend < value:
		value -= 100*delta
	
func _on_texture_progress_bar_value_changed(tovalue):
	await get_tree().create_timer(0.4).timeout
	intend = tovalue
