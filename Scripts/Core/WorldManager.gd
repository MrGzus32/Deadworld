extends Node2D

class_name WorldManager


# ==========================================
# DEADWORLD - WORLD MANAGER
# ==========================================

# Tamaño visual de una celda del mundo.
const TILE_WIDTH: float = 64.0
const TILE_HEIGHT: float = 32.0

# Altura visual de cada nivel.
const LEVEL_HEIGHT: float = 32.0


# ==========================================
# COORDENADAS 3D -> POSICIÓN ISOMÉTRICA 2D
# ==========================================

func world_to_screen(world_position: Vector3) -> Vector2:
	var iso_x = (world_position.x - world_position.y) * (TILE_WIDTH / 2.0)

	var iso_y = (
		(world_position.x + world_position.y)
		* (TILE_HEIGHT / 2.0)
		- world_position.z * LEVEL_HEIGHT
	)

	return Vector2(iso_x, iso_y)


# ==========================================
# POSICIÓN ISOMÉTRICA 2D -> COORDENADAS 3D
# ==========================================

func screen_to_world(screen_position: Vector2, z: float = 0.0) -> Vector3:
	var normalized_x = screen_position.x / (TILE_WIDTH / 2.0)

	var normalized_y = (
		screen_position.y + z * LEVEL_HEIGHT
	) / (TILE_HEIGHT / 2.0)

	var world_x = (normalized_x + normalized_y) / 2.0
	var world_y = (normalized_y - normalized_x) / 2.0

	return Vector3(world_x, world_y, z)
