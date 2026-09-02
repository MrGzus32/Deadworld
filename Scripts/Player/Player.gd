extends CharacterBody2D

class_name Player

# ============================================================
# DEADWORLD - PLAYER
# MOVIMIENTO FÍSICO ISOMÉTRICO
# ============================================================

const MOVE_SPEED: float = 180.0

var joystick: Control = null

# Posición lógica del jugador en el mundo 3D.
var world_position: Vector3 = Vector3.ZERO


func _ready() -> void:
	joystick = get_node_or_null(
		"../../UI/HUD/Joystick"
	)

	if joystick == null:
		push_error(
			"DEADWORLD: No se encontró el Joystick."
		)

	queue_redraw()


func _physics_process(_delta: float) -> void:
	handle_movement()
	queue_redraw()


func handle_movement() -> void:
	if joystick == null:
		velocity = Vector2.ZERO
		return

	var input_direction: Vector2 = (
		joystick.input_vector
	)

	if input_direction.length_squared() < 0.001:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if input_direction.length() > 1.0:
		input_direction = input_direction.normalized()

	# Convertimos el movimiento de pantalla
	# a movimiento lógico X/Y.
	var world_direction := Vector2(
		input_direction.x + input_direction.y,
		input_direction.y - input_direction.x
	)

	if world_direction.length() > 1.0:
		world_direction = world_direction.normalized()

	# Velocidad física.
	velocity = Vector2(
		world_direction.x,
		world_direction.y
	) * MOVE_SPEED

	move_and_slide()

	# Sincronizamos la posición física
	# con la posición lógica.
	world_position.x = position_to_world_x()
	world_position.y = position_to_world_y()


func position_to_world_x() -> float:
	var normalized_x: float = (
		position.x
		/ 32.0
	)

	var normalized_y: float = (
		position.y
		/ 16.0
	)

	return (
		normalized_x
		+ normalized_y
	) / 2.0


func position_to_world_y() -> float:
	var normalized_x: float = (
		position.x
		/ 32.0
	)

	var normalized_y: float = (
		position.y
		/ 16.0
	)

	return (
		normalized_y
		- normalized_x
	) / 2.0


func _draw() -> void:
	draw_circle(
		Vector2.ZERO,
		18.0,
		Color(
			0.8,
			0.8,
			0.8,
			1.0
		)
	)

	draw_circle(
		Vector2.ZERO,
		4.0,
		Color(
			0.2,
			0.2,
			0.2,
			1.0
		)
	)
