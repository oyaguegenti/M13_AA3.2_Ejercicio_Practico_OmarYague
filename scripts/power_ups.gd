extends Node3D

signal you_win


func _process(delta: float) -> void:
	if get_child_count() <= 0:
		you_win.emit()
		set_process(false)
