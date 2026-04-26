extends Node3D

@onready var timer = $Timer
@onready var hud = $hud

@onready var gameplay_music: AudioStreamPlayer = $GameplayMusic
@onready var win_music: AudioStreamPlayer = $WinMusic
@onready var lose_music: AudioStreamPlayer = $LoseMusic
@onready var coin_sfx: AudioStreamPlayer = $CoinSfx

var frases = [
	"Queda un mes de curso!",
	"Acabare el curso limpio",
	"No me quedara ninguna",
	"Triumfaras con el proyecto",
	"Prácticas remuneradas",
	"Los profes seran amables en la release"
]

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	for power_up in $PowerUps.get_children():
		power_up.suelta_frase.connect(_on_suelta_frase)

	Globals.total_coins = $PowerUps.get_child_count()
	hud.update_ui()

	start_gameplay_music()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func start_gameplay_music() -> void:
	if gameplay_music.stream != null:
		gameplay_music.stop()
		gameplay_music.play(0.0)

func stop_all_music() -> void:
	if gameplay_music.playing:
		gameplay_music.stop()

	if win_music.playing:
		win_music.stop()

	if lose_music.playing:
		lose_music.stop()

func _on_timer_timeout():
	Globals.countdown -= 1
	hud.update_ui()

	if Globals.countdown <= 0:
		timer.stop()
		game_over()

func game_over():
	stop_all_music()

	if lose_music.stream != null:
		lose_music.play()

	hud.show_game_over()

func _on_suelta_frase():
	var frase: String = frases.pick_random()
	$hud/Verdades.text = "[rainbow]" + frase + "[/rainbow]"

	await get_tree().create_timer(2.5).timeout

	$hud/Verdades.text = ""

func get_remaining_time_ms() -> int:
	var extra_ms: int = int(timer.time_left * 1000.0)
	var total_ms: int = Globals.countdown * 1000 + extra_ms
	return max(total_ms, 0)

func play_coin_sfx() -> void:
	if coin_sfx.stream != null:
		coin_sfx.play()

func _on_power_ups_you_win() -> void:
	var score_ms: int = get_remaining_time_ms()

	timer.stop()
	stop_all_music()

	if win_music.stream != null:
		win_music.play()

	DataBase.save_score(score_ms, Globals.coins)

	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	$YouWin.set_final_score(score_ms)
	$YouWin.visible = true
