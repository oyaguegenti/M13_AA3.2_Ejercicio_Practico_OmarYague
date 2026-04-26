extends Control


var variable:int = 33


func _ready() -> void:
	$Name.grab_focus()


func _on_play_button_pressed() -> void:
	var player_name:String = $Name.text
	
	if player_name == "":
		$InfoLabel.text = "Introduce un nombre"
		$Name.grab_focus()
		return

	var id_user = DataBase.insert_user(player_name)
	if id_user <= 0:
		push_error("ERROR: Al insertar en la base de datos")
		return
	
	Globals.username = player_name

	get_tree().change_scene_to_file("res://scenes/stage.tscn")

func _on_name_text_submitted(_new_text: String) -> void:
	_on_play_button_pressed()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_preferences_button_pressed() -> void:
	$Preferences.visible = true

func _on_records_button_pressed() -> void:
	$Records.open_panel()

func _on_credits_button_pressed() -> void:
	$Credits.visible = true
