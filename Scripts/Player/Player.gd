extends Node2D

class_name Player


# ==========================================
# DEADWORLD - PLAYER
# ==========================================

# Posición lógica del jugador en el mundo.
# X = Este/Oeste
# Y = Norte/Sur
# Z = Altura/nivel
var world_position: Vector3 = Vector3(0, 0, 0)


# Tamaño visual provisional.
const PLAYER_SIZE: float = 18.0


func _ready() -> void:
	queue_redraw()


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	# Cuerpo provisional del jugador.
	draw_circle(
		Vector2.ZERO,
		PLAYER_SIZE,
		Color(0.8, 0.8, 0.8, 1.0)
	)

	# Centro.
	draw_circle(
		Vector2.ZERO,
		4.0,
		Color(0.2, 0.2, 0.2, 1.0)
	)
