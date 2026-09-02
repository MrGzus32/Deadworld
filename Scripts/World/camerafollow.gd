extends Camera2D

class_name CameraFollow

# ==========================================
# DEADWORLD - CAMERA FOLLOW
# ==========================================

var player: Node2D = null


func _ready() -> void:

	player = get_node_or_null("../Players/Player")

	if player == null:
		push_error(
			"DEADWORLD: No se encontró el Player."
		)


func _process(_delta: float) -> void:

	if player == null:
		return

	global_position = player.global_position
