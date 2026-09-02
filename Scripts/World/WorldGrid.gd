extends Node2D

class_name WorldGrid

# ==========================================
# DEADWORLD - WORLD GRID
# ==========================================

const GRID_SIZE: int = 10

const TILE_WIDTH: float = 64.0
const TILE_HEIGHT: float = 32.0


func _ready() -> void:
	queue_redraw()


func _draw() -> void:

	for x in range(-GRID_SIZE, GRID_SIZE + 1):

		for y in range(-GRID_SIZE, GRID_SIZE + 1):

			draw_tile(Vector3(x, y, 0))


# ==========================================
# DIBUJAR UNA CELDA ISOMÉTRICA
# ==========================================

func draw_tile(world_position: Vector3) -> void:

	var screen_position := Vector2(
		(world_position.x - world_position.y)
		* (TILE_WIDTH / 2.0),

		(world_position.x + world_position.y)
		* (TILE_HEIGHT / 2.0)
	)

	var points := PackedVector2Array([
		screen_position + Vector2(
			0,
			-TILE_HEIGHT / 2.0
		),

		screen_position + Vector2(
			TILE_WIDTH / 2.0,
			0
		),

		screen_position + Vector2(
			0,
			TILE_HEIGHT / 2.0
		),

		screen_position + Vector2(
			-TILE_WIDTH / 2.0,
			0
		)
	])

	# Relleno
	draw_colored_polygon(
		points,
		Color(0.15, 0.18, 0.15, 1.0)
	)

	# Bordes
	draw_polyline(
		points + PackedVector2Array([points[0]]),
		Color(0.35, 0.40, 0.35, 1.0),
		1.0
	)
