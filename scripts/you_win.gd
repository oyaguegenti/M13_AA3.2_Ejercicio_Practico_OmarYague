extends Control

func set_final_score(score_ms: int) -> void:
	$FinalScore.text = "Puntuación final: ⏱️%dms" % score_ms

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	Globals.game_restart()
	get_tree().reload_current_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
