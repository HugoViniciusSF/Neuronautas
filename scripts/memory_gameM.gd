extends Node2D

@onready var status_label: Label = $Label
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var back_button: Button = $VBoxContainer/BackButton
@onready var pads_container: GridContainer = $VBoxContainer/GridContainer
@onready var game_timer: Timer = $GameTimer 

const PADS = ["GreenPad", "RedPad", "YellowPad", "BluePad", "OrangePad", "CianoPad"]
var original_pad_colors: Dictionary = {}
var sequence: Array[String] = []
var player_sequence: Array[String] = []
var level: int = 0

var _current_sequence_index: int = 0
var _is_showing_pad: bool = false
var _current_pad_to_hide: String = ""

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	for pad_name in PADS:
		var pad_node: Button = pads_container.get_node(pad_name)
		pad_node.pressed.connect(_on_pad_pressed.bind(pad_name))
		var color_rect: ColorRect = pad_node.get_node("ColorRect")
		if color_rect:
			original_pad_colors[pad_name] = color_rect.color
	
	status_label.text = "Pressione iniciar para começar!"
	_set_pads_disabled(true) 

# --- Funções de Controle do Jogo ---

func _set_pads_disabled(is_disabled: bool) -> void:
	for pad_name in PADS:
		var pad_node: Button = pads_container.get_node(pad_name)
		pad_node.disabled = is_disabled

func _on_start_button_pressed() -> void:
	_set_pads_disabled(false)
	level = 0
	sequence.clear()
	start_button.disabled = true
	start_button.text = "Em Jogo..."
	next_round()

func next_round() -> void:
	level += 1
	status_label.text = "Nível %d" % level
	player_sequence.clear()
	sequence.append(PADS.pick_random())
	
	status_label.text = "Observe a sequência..."
	game_timer.start(1.0)
	_is_showing_pad = true
	_current_sequence_index = 0

func _on_game_timer_timeout() -> void:
	if not _current_pad_to_hide.is_empty():
		var color_rect: ColorRect = pads_container.get_node(_current_pad_to_hide).get_node("ColorRect")
		color_rect.color = original_pad_colors[_current_pad_to_hide]
		_current_pad_to_hide = ""
		
		game_timer.start(0.3)
		return

	if _is_showing_pad:
		if _current_sequence_index >= sequence.size():
			_is_showing_pad = false
			status_label.text = "Sua vez! Repita a sequência."
			return
		
		var pad_name = sequence[_current_sequence_index]
		var color_rect: ColorRect = pads_container.get_node(pad_name).get_node("ColorRect")
		color_rect.color = Color.WHITE
		_current_pad_to_hide = pad_name
		
		_current_sequence_index += 1
		game_timer.start(0.5)
		
func _on_pad_pressed(pad_name: String) -> void:
	if _is_showing_pad:
		return

	var color_rect: ColorRect = pads_container.get_node(pad_name).get_node("ColorRect")
	color_rect.color = Color.WHITE
	get_tree().create_timer(0.2).timeout.connect(
		func(): 
			color_rect.color = original_pad_colors[pad_name]
	)
	
	player_sequence.append(pad_name)

	var current_index = player_sequence.size() - 1
	if player_sequence[current_index] != sequence[current_index]:
		end_game("Sequência incorreta!")
		return

	if player_sequence.size() == sequence.size():
		status_label.text = "Correto!"
		get_tree().create_timer(1.0).timeout.connect(next_round)

func end_game(message: String) -> void:
	status_label.text = "%s Você alcançou o nível %d." % [message, level]
	start_button.disabled = false
	start_button.text = "Tentar Novamente"
	
	_set_pads_disabled(true)
	
	game_timer.stop()
	_is_showing_pad = false
	_current_pad_to_hide = ""

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/memory_menu.tscn")


func _on_blue_pad_pressed():
	pass # Replace with function body.


func _on_yellow_pad_pressed():
	pass # Replace with function body.


func _on_red_pad_pressed():
	pass # Replace with function body.


func _on_green_pad_pressed():
	pass # Replace with function body.


func _on_orange_pad_pressed():
	pass # Replace with function body.


func _on_ciano_pad_pressed():
	pass # Replace with function body.
