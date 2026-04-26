extends CanvasLayer

@onready var coins_label = $MarginContainer/VBoxContainer/CoinsLabel
@onready var time_label = $MarginContainer/VBoxContainer/TimeLabel
@onready var coins_left_label = $MarginContainer/VBoxContainer/CoinsLeft
@onready var game_over_panel = $GameOverPanel
@onready var game_over_label = $GameOverPanel/CenterContainer/VBoxContainer/GameOverLabel
@onready var restart_button = $GameOverPanel/CenterContainer/VBoxContainer/RestartButton

func _ready():
	game_over_panel.visible = false
	restart_button.pressed.connect(_on_restart_pressed)
	update_ui()

func update_ui():
	coins_label.text = "Coins: " + str(Globals.coins)
	time_label.text = "Time: " + str(Globals.countdown) + "s"

	var coins_left: int = Globals.total_coins - Globals.coins
	if coins_left < 0:
		coins_left = 0

	coins_left_label.text = "Coins left: " + str(coins_left)

func show_game_over():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	game_over_panel.visible = true
	game_over_label.bbcode_enabled = true
	game_over_label.text = "[center][wave amp=50 freq=2][color=red]GAME OVER[/color][/wave]\n[color=yellow]Puntuación final: 0 ms[/color][/center]"

func _on_restart_pressed():
	Globals.game_restart()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_restart_button_pressed() -> void:
	pass # Replace with function body.
