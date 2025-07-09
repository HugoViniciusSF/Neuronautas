extends Control

var custom_start_time = 60.0

@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel

# Caminhos para os outros nós.
@onready var start_button = $StartButton
@onready var back_button = $BackButton
@onready var game_area = $VBoxContainer/GameArea
@onready var target = $VBoxContainer/GameArea/Target
@onready var background_button = $VBoxContainer/GameArea/BackgroundButton
@onready var game_timer = $GameTimer

# Caminhos para os nós do popup
@onready var time_picker_dialog = $TimePickerDialog
@onready var time_input = $TimePickerDialog/TimeInput
@onready var neuronautas_reflex = $NeuronautasReflex 

var score = 0
var time_left = 0.0
var game_active = false

func _ready():
	target.pressed.connect(_on_target_pressed)
	start_button.pressed.connect(_on_start_button_pressed)
	background_button.pressed.connect(_on_background_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	game_timer.timeout.connect(_on_game_timer_timeout)
	time_picker_dialog.confirmed.connect(_on_time_picker_dialog_confirmed)

	game_area.visible = false
	background_button.disabled = true
	timer_label.text = " %.1f" % custom_start_time
	start_button.text = "Jogar"

func _unhandled_input(event):
	
	if not game_active and start_button.text == "Jogar Novamente":
		
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			
			if neuronautas_reflex.get_rect().has_point(neuronautas_reflex.to_local(event.position)):
				
				_open_time_picker()


func _process(_delta):
	if game_active:
		time_left -= _delta
		
		if time_left <= 0:
			time_left = 0
			_end_game()
		
		timer_label.text = " %.1f" % time_left

func _on_start_button_pressed():
	if start_button.text == "Jogar Novamente":
		_start_game()
	else:
		_open_time_picker()


func _open_time_picker():
	time_input.text = str(custom_start_time)
	time_picker_dialog.popup_centered()

func _on_time_picker_dialog_confirmed():
	var input_text = time_input.text
	if input_text.is_valid_float() and float(input_text) > 0:
		custom_start_time = float(input_text)
		_start_game()
	else:
		push_warning("Valor de tempo inválido inserido.")
		_start_game()

func _start_game():
	score = 0
	time_left = custom_start_time
	game_active = true
	
	score_label.text = " 0"
	timer_label.text = " %.1f" % time_left
	
	start_button.disabled = true
	
	game_area.visible = true
	background_button.disabled = false
	
	spawn_target()

func _on_target_pressed():
	if not game_active:
		return
	
	game_timer.stop()
	score += 1
	score_label.text = " %d" % score
	
	spawn_target()

func _on_background_button_pressed():
	if game_active:
		_end_game()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/reflex_menu.tscn")

func _end_game():
	game_active = false
	game_timer.stop()
	
	target.visible = false
	
	start_button.disabled = false
	start_button.text = "Jogar Novamente"
	
	background_button.disabled = true

func spawn_target():
	target.visible = true
	
	var game_area_size = game_area.size
	var target_size = target.custom_minimum_size
	
	var rand_x = randf_range(0, game_area_size.x - target_size.x)
	var rand_y = randf_range(0, game_area_size.y - target_size.y)
	
	target.position = Vector2(rand_x, rand_y)
	game_timer.start()

func _on_game_timer_timeout():
	if game_active:
		spawn_target()
