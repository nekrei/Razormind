extends CanvasLayer

func _ready():
	$NinePatchRect/InventoryHUD.updating()

func _on_player_update_inv():
	$NinePatchRect/InventoryHUD.updating()
