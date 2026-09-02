extends Node2D

class_name WorldManager


# ============================================================
# DEADWORLD - WORLD MANAGER
# ============================================================


const TILE_WIDTH: float = 64.0
const TILE_HEIGHT: float = 32.0
const LEVEL_HEIGHT: float = 32.0


# ============================================================
# REFERENCIAS
# ============================================================

var player: Node2D = null

var world_grid: WorldGrid = null


# ============================================================
# INICIO
# ============================================================

func _ready() -> void:

	print("================================")
	print("DEADWORLD: WORLD MANAGER ACTIVO")
	print("================================")


	player = get_node_or_null(
		"../../Players/Player"
	)


	if player == null:

		push_error(
			"DEADWORLD: NO SE ENCONTRÓ EL PLAYER."
		)

		return


	print("PLAYER ENCONTRADO")


	world_grid = get_node_or_null(
		"../../Map"
	)


	if world_grid == null:

		push_error(
			"DEADWORLD: NO SE ENCONTRÓ WORLD GRID."
		)

		return


	print("WORLD GRID ENCONTRADO")


	update_player_position()


	print(
		"POSICIÓN LÓGICA: ",
		player.world_position
	)


	print(
		"POSICIÓN VISUAL: ",
		player.position
	)


# ============================================================
# PROCESO
# ============================================================

func _process(_delta: float) -> void:

	if player == null:
		return


	if world_grid == null:
		return


	update_player_height()

	update_player_position()


# ============================================================
# ACTUALIZAR ALTURA
# ============================================================

func update_player_height() -> void:

	var height: int = world_grid.get_height_at(
		player.world_position
	)


	player.world_position.z = height


# ============================================================
# ACTUALIZAR POSICIÓN VISUAL
# ============================================================

func update_player_position() -> void:

	var world_position: Vector3 = (
		player.world_position
	)


	player.position = world_to_screen(
		world_position
	)


# ============================================================
# MUNDO -> PANTALLA
# ============================================================

func world_to_screen(
	world_position: Vector3
) -> Vector2:

	var screen_x: float = (
		world_position.x
		- world_position.y
	) * (
		TILE_WIDTH / 2.0
	)


	var screen_y: float = (
		world_position.x
		+ world_position.y
	) * (
		TILE_HEIGHT / 2.0
	)


	screen_y -= (
		world_position.z
		* LEVEL_HEIGHT
	)


	return Vector2(
		screen_x,
		screen_y
	)


# ============================================================
# PANTALLA -> MUNDO
# ============================================================

func screen_to_world(
	screen_position: Vector2,
	z: float = 0.0
) -> Vector3:

	var normalized_x: float = (
		screen_position.x
		/ (TILE_WIDTH / 2.0)
	)


	var normalized_y: float = (
		screen_position.y
		+ z * LEVEL_HEIGHT
	) / (
		TILE_HEIGHT / 2.0
	)


	var world_x: float = (
		normalized_x
		+ normalized_y
	) / 2.0


	var world_y: float = (
		normalized_y
		- normalized_x
	) / 2.0


	return Vector3(
		world_x,
		world_y,
		z
	)
