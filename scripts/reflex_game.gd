extends Control

# CAMINHO ATUALIZADO: Os labels agora são acessados diretamente do nó raiz.
@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel

# Caminhos para os outros nós.
@onready var start_button = $StartButton
@onready var back_button = $BackButton
@onready var game_area = $VBoxContainer/GameArea
@onready var target = $VBoxContainer/GameArea/Target
@onready var background_button = $VBoxContainer/GameArea/BackgroundButton

var score = 0
var time_elapsed = 0.0
var game_active = false

func _ready():
	target.pressed.connect(_on_target_pressed)
	start_button.pressed.connect(_on_start_button_pressed)
	background_button.pressed.connect(_on_background_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	game_area.visible = false
	background_button.disabled = true

func _process(_delta):
	if game_active:
		time_elapsed += _delta
		timer_label.text = " %.1f" % time_elapsed

func _on_start_button_pressed():
	score = 0
	time_elapsed = 0.0
	game_active = true
	
	score_label.text = " 0"
	timer_label.text = " 0.0s"
	
	start_button.disabled = true
	
	game_area.visible = true
	background_button.disabled = false
	
	spawn_target()

func _on_target_pressed():
	if not game_active:
		return
		
	score += 1
	score_label.text = " %d" % score
	
	spawn_target()

func _on_background_button_pressed():
	game_active = false
	
	target.visible = false
	
	start_button.disabled = false
	start_button.text = "Jogar Novamente"
	
	#timer_label.text = "FIM DE JOGO!"
	background_button.disabled = true

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func spawn_target():
	target.visible = true
	
	var game_area_size = game_area.size
	var target_size = target.custom_minimum_size
	
	var rand_x = randf_range(0, game_area_size.x - target_size.x)
	var rand_y = randf_range(0, game_area_size.y - target_size.y)
	
	target.position = Vector2(rand_x, rand_y)
