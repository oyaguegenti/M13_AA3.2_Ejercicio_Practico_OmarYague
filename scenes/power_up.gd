extends Area3D

signal suelta_frase


func _on_body_entered(body: Node3D) -> void:
	suelta_frase.emit()

	Globals.coins += 1
	
	var stage = get_tree().current_scene
	if stage.has_node("HUD"):
		stage.get_node("HUD").update_ui()
	
	$CollisionShape3D.set_deferred("disabled", true)
	$MeshInstance3D.visible = false
	$GPUParticles3D.emitting = true
	
	await $GPUParticles3D.finished
	
	queue_free()
