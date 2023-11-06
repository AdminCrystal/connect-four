extends Node

func _ready() -> void:
	if OS.is_debug_build():
		DisplayServer.window_set_size(Vector2i(540, 960))
		DisplayServer.window_set_position(Vector2i(900, 200))
