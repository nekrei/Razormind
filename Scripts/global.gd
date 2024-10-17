extends Node

var collectible : Array
var ResParent := "res://Resources/Invincible/"

func loadColl():
	for x in DirAccess.get_files_at(ResParent):
		collectible.append(load(ResParent+x))

var currentInvincible = ""
var Wave = 1
