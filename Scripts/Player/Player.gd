extends Node2D

class_name Player

# ==========================================
# DEADWORLD - PLAYER
# ==========================================

# Posición lógica del jugador.
#
# X = Este / Oeste
# Y = Norte / Sur
# Z = Altura / Nivel
#
# IMPORTANTE:
# Esta es la posición REAL del jugador.
# La posición Node2D solamente representa
# dónde se dibuja en pantalla.

var world_position: Vector3 = Vector3(3, 0, 0)


# ==========================================
# APARIENCIA PROVISIONAL
# ==========================================

const PLAYER_SIZE: float = 18.0


func _ready() -> void:
	queue_redraw()


func _process(_delta: float) -> void:
	queue_redraw()


# ==========================================
# DIBUJO PROVISIONAL
# ==========================================

func _draw() -> void:

	# Cuerpo
	draw_circle(
		Vector2.ZERO,
		PLAYER_SIZE,
		Color(0.8, 0.8, 0.8, 1.0)
	)

	# Centro
	draw_circle(
		Vector2.ZERO,
		4.0,
		Color(0.2, 0.2, 0.2, 1.0)
	)
