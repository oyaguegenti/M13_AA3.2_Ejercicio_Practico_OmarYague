extends ColorRect


func _ready() -> void:
	$CenterContainer/VBoxContainer/VolumeSlider.value = Globals.volume
	$CenterContainer/VBoxContainer/FullScreenBox.button_pressed = Globals.full_screen


func _on_full_screen_box_toggled(toggled_on: bool) -> void:
	Globals.full_screen_toggled(toggled_on)
		
	#await get_tree().create_timer(1).timeout
	#$BSOD.visible = true


func _on_volume_slider_value_changed(value: float) -> void:
	Globals.volume_changed(value)


func _on_back_button_pressed() -> void:
	visible = false
	Globals.save_preferences()
	
	
	
	
	
	
	
