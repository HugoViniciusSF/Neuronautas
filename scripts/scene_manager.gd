extends Node2D

func goto_scene(path: String):
	"""
	Carrega uma nova cena.
	O get_tree().change_scene_to_file() é o método padrão da Godot para trocar a cena atual.
	"""
	get_tree().change_scene_to_file(path)

