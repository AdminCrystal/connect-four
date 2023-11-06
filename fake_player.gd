#extends Sprite2D
#
#
#var tile_size = 64
#var game_size = 7
#var inputs = {"right": Vector2.RIGHT,
#			"left": Vector2.LEFT,
#			"up": Vector2.UP,
#			"down": Vector2.DOWN}
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	position = position.snapped(Vector2.ONE * tile_size)
#	position += Vector2.ONE * tile_size/2
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
#
#
#func _unhandled_input(event):
#	for dir in inputs.keys():
#		if event.is_action_pressed(dir):
#			move(dir)
#
#func move(dir):
#	position += inputs[dir] * tile_size
#
#
#func _input(event):
#   # Mouse in viewport coordinates.
#	if event is InputEventMouseButton:
#		var window_size = DisplayServer.window_get_size().x
#
#		print("Mouse Click/Unclick at: ", event.position)
#		position = position.snapped(Vector2.ONE * tile_size)
#
