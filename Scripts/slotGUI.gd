extends Panel

func update(what):
	$item.texture = what.texture

func remove():
	$item.texture = null
