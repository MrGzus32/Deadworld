extends Node2D

class_name WorldGrid


# ============================================================
# DEADWORLD - WORLD GRID
# TERRENO PROCEDURAL + ALTURA Z
# OPTIMIZADO PARA ANDROID
# ============================================================


# ============================================================
# TAMAÑO VISUAL
# ============================================================

const TILE_WIDTH: float = 64.0
const TILE_HEIGHT: float = 32.0


# ============================================================
# CHUNKS
# ============================================================

const CHUNK_SIZE: int = 4

const VIEW_DISTANCE: int = 1


# ============================================================
# SEED
# ============================================================

const WORLD_SEED: int = 12345


# ============================================================
# TERRENOS
# ============================================================

const TERRAIN_GRASS: int = 0
const TERRAIN_FOREST: int = 1
const TERRAIN_ROAD: int = 2
const TERRAIN_WATER: int = 3
const TERRAIN_MOUNTAIN: int = 4


# ============================================================
# DATOS DEL MUNDO
# ============================================================

var terrain_map: Dictionary = {}

var height_map: Dictionary = {}

var loaded_chunks: Dictionary = {}

var current_player_chunk: Vector2i = Vector2i(
	999999,
	999999
)

var player: Node2D = null

var noise: FastNoiseLite


# ============================================================
# INICIO
# ============================================================

func _ready() -> void:

	player = get_node_or_null(
		"../Players/Player"
	)

	if player == null:

		push_error(
			"DEADWORLD: No se encontró Players/Player."
		)

		return


	# --------------------------------------------------------
	# GENERADOR PRINCIPAL
	# --------------------------------------------------------

	noise = FastNoiseLite.new()

	noise.seed = WORLD_SEED

	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH

	noise.frequency = 0.08


	# --------------------------------------------------------
	# CHUNK INICIAL
	# --------------------------------------------------------

	current_player_chunk = world_to_chunk(
		player.world_position
	)


	update_visible_chunks()

	queue_redraw()


# ============================================================
# PROCESO
# ============================================================

func _process(_delta: float) -> void:

	if player == null:
		return


	var new_chunk: Vector2i = world_to_chunk(
		player.world_position
	)


	if new_chunk == current_player_chunk:
		return


	current_player_chunk = new_chunk

	update_visible_chunks()

	queue_redraw()


# ============================================================
# ACTUALIZAR CHUNKS
# ============================================================

func update_visible_chunks() -> void:

	var required_chunks: Dictionary = {}


	# --------------------------------------------------------
	# CHUNKS CERCANOS
	# --------------------------------------------------------

	for x in range(
		current_player_chunk.x - VIEW_DISTANCE,
		current_player_chunk.x + VIEW_DISTANCE + 1
	):

		for y in range(
			current_player_chunk.y - VIEW_DISTANCE,
			current_player_chunk.y + VIEW_DISTANCE + 1
		):

			var chunk_position := Vector2i(
				x,
				y
			)

			required_chunks[chunk_position] = true


			if not loaded_chunks.has(
				chunk_position
			):

				generate_chunk(
					chunk_position
				)


	# --------------------------------------------------------
	# DESCARGAR CHUNKS LEJANOS
	# --------------------------------------------------------

	var chunks_to_remove: Array[Vector2i] = []


	for chunk_position in loaded_chunks.keys():

		if not required_chunks.has(
			chunk_position
		):

			chunks_to_remove.append(
				chunk_position
			)


	for chunk_position in chunks_to_remove:

		unload_chunk(
			chunk_position
		)


# ============================================================
# GENERAR CHUNK
# ============================================================

func generate_chunk(
	chunk_position: Vector2i
) -> void:

	loaded_chunks[chunk_position] = true


	var start_x: int = (
		chunk_position.x
		* CHUNK_SIZE
	)

	var start_y: int = (
		chunk_position.y
		* CHUNK_SIZE
	)


	for local_x in range(CHUNK_SIZE):

		for local_y in range(CHUNK_SIZE):

			var world_x: int = (
				start_x
				+ local_x
			)

			var world_y: int = (
				start_y
				+ local_y
			)


			var terrain_type: int = generate_terrain(
				world_x,
				world_y
			)


			var height: int = generate_height(
				world_x,
				world_y,
				terrain_type
			)


			var position := Vector2i(
				world_x,
				world_y
			)


			terrain_map[position] = terrain_type

			height_map[position] = height


# ============================================================
# DESCARGAR CHUNK
# ============================================================

func unload_chunk(
	chunk_position: Vector2i
) -> void:

	loaded_chunks.erase(
		chunk_position
	)


	var start_x: int = (
		chunk_position.x
		* CHUNK_SIZE
	)

	var start_y: int = (
		chunk_position.y
		* CHUNK_SIZE
	)


	for local_x in range(CHUNK_SIZE):

		for local_y in range(CHUNK_SIZE):

			var world_x: int = (
				start_x
				+ local_x
			)

			var world_y: int = (
				start_y
				+ local_y
			)


			var position := Vector2i(
				world_x,
				world_y
			)


			terrain_map.erase(
				position
			)

			height_map.erase(
				position
			)


# ============================================================
# GENERAR TIPO DE TERRENO
# ============================================================

func generate_terrain(
	x: int,
	y: int
) -> int:

	# --------------------------------------------------------
	# CARRETERA
	# --------------------------------------------------------

	if y == 0:
		return TERRAIN_ROAD


	# --------------------------------------------------------
	# RUIDO
	# --------------------------------------------------------

	var value: float = noise.get_noise_2d(
		float(x),
		float(y)
	)


	var normalized: float = (
		value + 1.0
	) * 0.5


	# --------------------------------------------------------
	# AGUA
	# --------------------------------------------------------

	if normalized < 0.20:
		return TERRAIN_WATER


	# --------------------------------------------------------
	# MONTAÑA
	# --------------------------------------------------------

	if normalized > 0.80:
		return TERRAIN_MOUNTAIN


	# --------------------------------------------------------
	# BOSQUE
	# --------------------------------------------------------

	if normalized > 0.55:
		return TERRAIN_FOREST


	# --------------------------------------------------------
	# HIERBA
	# --------------------------------------------------------

	return TERRAIN_GRASS


# ============================================================
# GENERAR ALTURA Z
# ============================================================

func generate_height(
	x: int,
	y: int,
	terrain_type: int
) -> int:

	# --------------------------------------------------------
	# AGUA
	# --------------------------------------------------------

	if terrain_type == TERRAIN_WATER:
		return 0


	# --------------------------------------------------------
	# CARRETERA
	# --------------------------------------------------------

	if terrain_type == TERRAIN_ROAD:
		return 0


	# --------------------------------------------------------
	# TERRENO NORMAL
	# --------------------------------------------------------

	if terrain_type != TERRAIN_MOUNTAIN:
		return 0


	# --------------------------------------------------------
	# ALTURA DE MONTAÑA
	# --------------------------------------------------------

	var value: float = noise.get_noise_2d(
		float(x) + 500.0,
		float(y) + 500.0
	)


	var normalized: float = (
		value + 1.0
	) * 0.5


	if normalized > 0.85:
		return 3


	if normalized > 0.65:
		return 2


	return 1


# ============================================================
# OBTENER ALTURA
# ============================================================

func get_height(
	x: int,
	y: int
) -> int:

	var position := Vector2i(
		x,
		y
	)

	return int(
		height_map.get(
			position,
			0
		)
	)


# ============================================================
# OBTENER ALTURA DESDE POSICIÓN
# ============================================================

func get_height_at(
	world_position: Vector3
) -> int:

	return get_height(
		floori(world_position.x),
		floori(world_position.y)
	)


# ============================================================
# MUNDO -> CHUNK
# ============================================================

func world_to_chunk(
	world_position: Vector3
) -> Vector2i:

	var chunk_x: int = floori(
		world_position.x
		/ float(CHUNK_SIZE)
	)

	var chunk_y: int = floori(
		world_position.y
		/ float(CHUNK_SIZE)
	)


	return Vector2i(
		chunk_x,
		chunk_y
	)


# ============================================================
# DIBUJAR
# ============================================================

func _draw() -> void:

	for position in terrain_map:

		var terrain_type: int = terrain_map[
			position
		]


		var height: int = height_map.get(
			position,
			0
		)


		var world_position := Vector3(
			position.x,
			position.y,
			height
		)


		draw_tile(
			world_position,
			terrain_type
		)


# ============================================================
# DIBUJAR TILE
# ============================================================

func draw_tile(
	world_position: Vector3,
	terrain_type: int
) -> void:

	var screen_position: Vector2 = world_to_screen(
		world_position
	)


	var half_width: float = (
		TILE_WIDTH / 2.0
	)

	var half_height: float = (
		TILE_HEIGHT / 2.0
	)


	var points := PackedVector2Array([
		screen_position + Vector2(
			0.0,
			-half_height
		),

		screen_position + Vector2(
			half_width,
			0.0
		),

		screen_position + Vector2(
			0.0,
			half_height
		),

		screen_position + Vector2(
			-half_width,
			0.0
		)
	])


	draw_colored_polygon(
		points,
		get_terrain_color(
			terrain_type
		)
	)


# ============================================================
# X/Y/Z -> PANTALLA
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


	# --------------------------------------------------------
	# Z ELEVA EL TILE
	# --------------------------------------------------------

	screen_y -= (
		world_position.z
		* TILE_HEIGHT
	)


	return Vector2(
		screen_x,
		screen_y
	)


# ============================================================
# COLORES
# ============================================================

func get_terrain_color(
	terrain_type: int
) -> Color:

	match terrain_type:

		TERRAIN_GRASS:
			return Color(
				0.15,
				0.18,
				0.15,
				1.0
			)


		TERRAIN_FOREST:
			return Color(
				0.08,
				0.20,
				0.10,
				1.0
			)


		TERRAIN_ROAD:
			return Color(
				0.25,
				0.25,
				0.23,
				1.0
			)


		TERRAIN_WATER:
			return Color(
				0.08,
				0.16,
				0.25,
				1.0
			)


		TERRAIN_MOUNTAIN:
			return Color(
				0.30,
				0.28,
				0.25,
				1.0
			)


		_:
			return Color(
				0.15,
				0.18,
				0.15,
				1.0
			)
