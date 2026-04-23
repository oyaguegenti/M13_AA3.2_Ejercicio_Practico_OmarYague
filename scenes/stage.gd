extends Node3D


@onready var timer = $Timer
@onready var hud = $hud

var frases = [
	"Sigue tus sueños",
	"Vais a aprobar la Vertical",
	"Si repites esta asignatura es por tu bien",
	"Tienes muchos amigos",
	"Prácticas remuneradas",
	"Richard será amable en la Vertical"
	
]


func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	hud.update_ui()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	for power_up in $PowerUps.get_children():
		power_up.suelta_frase.connect(_on_suelta_frase)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED




func _on_timer_timeout():
	Globals.countdown -= 1
	hud.update_ui()
	
	if Globals.countdown <= 0:
		timer.stop()
		game_over()


func game_over():
	hud.show_game_over()
	
	DataBase.save_score ()


func _on_suelta_frase ():
	var frase:String = frases.pick_random()

	$hud/Verdades.text = "[rainbow]"+frase+"[/rainbow]"
	
	await get_tree().create_timer(2.5).timeout
	
	$hud/Verdades.text = ""


func _on_power_ups_you_win() -> void:
	get_tree().paused = true
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	$YouWin.visible = true
