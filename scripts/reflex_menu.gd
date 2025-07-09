extends Node2D

func _on_reflexML_button_pressed():
	SceneManager.goto_scene("res://scenes/reflex_game.tscn")

func _on_reflex30_button_pressed():
	SceneManager.goto_scene("res://scenes/reflex_game30.tscn")

func _on_reflex60_button_pressed():
	SceneManager.goto_scene("res://scenes/reflex_game60.tscn")

func _on_reflexP_button_pressed():
	SceneManager.goto_scene("res://scenes/reflex_gameP.tscn")
	
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
