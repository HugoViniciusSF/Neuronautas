extends Node2D

func _on_memoryE_button_pressed():
	SceneManager.goto_scene("res://scenes/memory_game.tscn")

func _on_memoryM_button_pressed():
	SceneManager.goto_scene("res://scenes/memory_gameM.tscn")

func _on_memoryH_button_pressed():
	SceneManager.goto_scene("res://scenes/memory_gameH.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
