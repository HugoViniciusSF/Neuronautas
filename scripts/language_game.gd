
extends Control

@onready var status_label = $VBoxContainer/StatusLabel
@onready var letter_pool_container = $VBoxContainer/LetterPool
@onready var word_input = $VBoxContainer/WordInput
@onready var found_words_display = $VBoxContainer/FoundWords
@onready var start_button = $VBoxContainer/StartButton
@onready var back_button = $VBoxContainer/BackButton

const WORD_SETS = [
	{
		"theme": "Frutas", 
		"words": ["maçã", "banana", "laranja", "uva", "morango", "abacaxi", "manga", "limão"]
	},
	{
		"theme": "Animais Mamíferos", 
		"words": ["cão", "gato", "leão", "tigre", "elefante", "macaco", "cavalo", "vaca", "urso", "baleia"]
	},
	{
		"theme": "Cores", 
		"words": ["vermelho", "azul", "amarelo", "verde", "roxo", "laranja", "branco", "preto", "cinza", "rosa"]
	},
	{
		"theme": "Partes do Corpo",
		"words": ["cabeça", "braço", "perna", "mão", "pé", "olho", "boca", "nariz", "orelha"]
	},
	{
		"theme": "Objetos da Escola",
		"words": ["lápis", "caneta", "caderno", "livro", "borracha", "régua", "mochila", "tesoura"]
	}
]

var current_word_list = []
var found_words = []
var total_words_in_round = 0

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	word_input.text_submitted.connect(_on_word_input_text_submitted)
	
	letter_pool_container.visible = false

func _on_start_button_pressed():
	found_words.clear()
	word_input.editable = true
	word_input.text = ""
	found_words_display.text = "Palavras encontradas:"
	start_button.disabled = true
	
	var current_set = WORD_SETS.pick_random()
	current_word_list = current_set["words"]
	total_words_in_round = current_word_list.size()
	status_label.text = "Tema: %s  |  Palavras: %d / %d" % [current_set["theme"], 0, total_words_in_round]
	
	word_input.grab_focus()

func _on_word_input_text_submitted(text: String):
	var submitted_word = text.to_lower().strip_edges()
	
	if submitted_word in current_word_list and not submitted_word in found_words:
		found_words.append(submitted_word)
		found_words_display.text += "\n - " + submitted_word
		
		var current_theme = status_label.text.split("  |  ")[0] 
		status_label.text = "%s  |  Palavras: %d / %d" % [current_theme, found_words.size(), total_words_in_round]
		
		if found_words.size() == total_words_in_round:
			win_game()
	
	word_input.text = ""
	word_input.grab_focus()

func win_game():
	word_input.editable = false
	status_label.text = "Parabens! encontrado todas as palavras!"
	start_button.disabled = false
	start_button.text = "Jogar Novamente"

func _on_back_button_pressed():
	SceneManager.goto_scene("res://scenes/main_menu.tscn")

