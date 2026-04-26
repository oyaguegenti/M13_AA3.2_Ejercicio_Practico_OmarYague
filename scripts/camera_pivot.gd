extends Node3D

var rotate_speed:float = 15.0


func _process(delta: float) -> void:
	rotation_degrees.y += rotate_speed * delta
