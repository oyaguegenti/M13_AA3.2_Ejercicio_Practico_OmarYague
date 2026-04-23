extends Node


@export var countdown: int = 60
@export var health:int = 10


var preferences_file = "user://preferences.json"

var coins:int = 0

var username:String = ""

var countdown_init:int = -1
var health_init:int = -1


var volume:float = 0.5
var full_screen:bool = false


func _ready():
	countdown_init = countdown
	health_init = health
	
	load_preferences()


func save_preferences ():
	var pref:Dictionary = {
		"volume": volume,
		"full_screen": full_screen
	}
	
	var pref_json:String = JSON.stringify(pref)

	var file = FileAccess.open(preferences_file, FileAccess.WRITE)
	
	file.store_string(pref_json)


func load_preferences ():
	if not FileAccess.file_exists(preferences_file):
		print("Warning: El archivo de prefrencias no existe.")
		return
		
	var file = FileAccess.open(preferences_file, FileAccess.READ)
	
	var pref_json:String = file.get_as_text()

	var pref = JSON.parse_string(pref_json)
	
	full_screen_toggled(pref["full_screen"])
	volume_changed(pref["volume"])





func game_restart ():
	coins = 0
	health = health_init
	countdown = countdown_init


func full_screen_toggled (toggle:bool):
	if toggle:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	full_screen = toggle
	

func volume_changed (value:float):
	var id_master = AudioServer.get_bus_index("Master")
	
	AudioServer.set_bus_volume_linear(id_master, value)
	
	volume = value
	
	
	
	
	
	
