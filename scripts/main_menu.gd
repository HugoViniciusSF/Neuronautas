extends Node2D

func _on_memory_button_pressed():
	SceneManager.goto_scene("res://scenes/memory_menu.tscn")

func _on_reflex_button_pressed():
	SceneManager.goto_scene("res://scenes/reflex_menu.tscn")

func _on_language_button_pressed():
	SceneManager.goto_scene("res://scenes/language_game.tscn")
