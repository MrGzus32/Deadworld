extends Node2D

class_name WorldManager

# ==========================================
# DEADWORLD - WORLD MANAGER
# ==========================================

# Tamaño visual de una celda.
const TILE_WIDTH: float = 64.0
const TILE_HEIGHT: float = 32.0

# Altura visual de cada nivel Z.
const LEVEL_HEIGHT: float = 32.0

# Referencia al jugador de la escena World.
@onready var player: Player = $"../../Players/Player"


func _ready() -> void:
	print("DEADWORLD: WorldManager iniciado")

	if player == null:
		push_error("DEADWORLD: No se encontró Players/Player")
		return

	update_player_position()


func _process(_delta: float) -> void:
	update_player_position()


# ==========================================
# ACTUALIZAR POSICIÓN VISUAL DEL JUGADOR
# ==========================================

func update_player_position() -> void:
	if player == null:
		return

	player.position = world_to_screen(player.world_position)


# ==========================================
# COORDENADAS 3D -> POSICIÓN ISOMÉTRICA 2D
# ==========================================

func world_to_screen(world_position: Vector3) -> Vector2:

	var iso_x := (
		world_position.x - world_position.y
	) * (TILE_WIDTH / 2.0)

	var iso_y := (
		(world_position.x + world_position.y)
		* (TILE_HEIGHT / 2.0)
		- world_position.z * LEVEL_HEIGHT
	)

	return Vector2(iso_x, iso_y)


# ==========================================
# POSICIÓN ISOMÉTRICA 2D -> COORDENADAS 3D
# ==========================================

func screen_to_world(
	screen_position: Vector2,
	z: float = 0.0
) -> Vector3:

	var normalized_x := (
		screen_position.x / (TILE_WIDTH / 2.0)
	)

	var normalized_y := (
		(screen_position.y + z * LEVEL_HEIGHT)
		/ (TILE_HEIGHT / 2.0)
	)

	var world_x := (
		normalized_x + normalized_y
	) / 2.0

	var world_y := (
		normalized_y - normalized_x
	) / 2.0

	return Vector3(world_x, world_y, z)
