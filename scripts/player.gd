extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var jump_sfx: AudioStreamPlayer = $JumpSfx
@onready var footstep_sfx: AudioStreamPlayer = $FootstepSfx

var rotation_speed: float = 0.0025

func _ready() -> void:
	$name3D.text = Globals.username

func _physics_process(delta: float) -> void:
	var on_floor_now: bool = is_on_floor()

	if not on_floor_now:
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and on_floor_now:
		velocity.y = JUMP_VELOCITY
		if jump_sfx.stream != null:
			jump_sfx.play()

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	update_footstep_audio()

func update_footstep_audio() -> void:
	var is_moving: bool = abs(velocity.x) > 0.1 or abs(velocity.z) > 0.1
	var should_play: bool = is_on_floor() and is_moving

	if should_play:
		if footstep_sfx.stream != null and not footstep_sfx.playing:
			footstep_sfx.play()
	else:
		if footstep_sfx.playing:
			footstep_sfx.stop()

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventMouseMotion):
		return

	rotation.y -= event.relative.x * rotation_speed
