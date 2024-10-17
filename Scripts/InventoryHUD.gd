extends HBoxContainer

@onready var Inventory :Inventory = preload("res://Resources/DummyInv.tres")
@onready var slots = self.get_children()

	
func updating():
	for i in range(min(Inventory.has.size(), slots.size())):
		if Inventory.has[i]:
			slots[i].update(Inventory.has[i])
		else:
			slots[i].remove()
