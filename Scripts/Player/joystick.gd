extends Control

# ==========================================
# DEADWORLD - VIRTUAL JOYSTICK
# ==========================================

const JOYSTICK_RADIUS: float = 80.0
const KNOB_RADIUS: float = 35.0

var input_vector: Vector2 = Vector2.ZERO

var touch_active: bool = false
var touch_index: int = -1
var joystick_center: Vector2 = Vector2.ZERO


func _ready() -> void:
	# El joystick ocupa toda la pantalla.
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Recibimos los eventos táctiles.
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	queue_redraw()


func _input(event: InputEvent) -> void:

	# ======================================
	# TOCAR LA PANTALLA
	# ======================================

	if event is InputEventScreenTouch:

		if event.pressed:

			# Si ya estamos usando un dedo, ignoramos otros.
			if touch_active:
				return

			touch_active = true
			touch_index = event.index

			# El joystick aparece donde tocamos.
			joystick_center = event.position

			input_vector = Vector2.ZERO

			queue_redraw()

		else:

			# Soltamos el joystick.
			if event.index == touch_index:

				touch_active = false
				touch_index = -1

				input_vector = Vector2.ZERO

				queue_redraw()


	# ======================================
	# ARRASTRAR EL DEDO
	# ======================================

	elif event is InputEventScreenDrag:

		if not touch_active:
			return

		if event.index != touch_index:
			return

		var offset: Vector2 = event.position - joystick_center

		# Limitar el movimiento de la palanca.
		if offset.length() > JOYSTICK_RADIUS:
			offset = offset.normalized() * JOYSTICK_RADIUS

		input_vector = offset / JOYSTICK_RADIUS

		queue_redraw()


func _draw() -> void:

	# Si no estamos tocando, no dibujamos el joystick.
	if not touch_active:
		return

	# ======================================
	# BASE
	# ======================================

	draw_circle(
		joystick_center,
		JOYSTICK_RADIUS,
		Color(0.15, 0.15, 0.15, 0.65)
	)

	# ======================================
	# BORDE
	# ======================================

	draw_arc(
		joystick_center,
		JOYSTICK_RADIUS,
		0.0,
		TAU,
		32,
		Color(0.7, 0.7, 0.7, 0.8),
		3.0
	)

	# ======================================
	# PALANCA
	# ======================================

	var knob_position: Vector2 = (
		joystick_center
		+ input_vector * JOYSTICK_RADIUS
	)

	draw_circle(
		knob_position,
		KNOB_RADIUS,
		Color(0.8, 0.8, 0.8, 0.9)
	)
