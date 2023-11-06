class_name C4Structs

class PositionDetails extends Resource:
	var position: int
	var index: int
	var is_valid: bool

class MatrixDetails extends Resource:
	var player_name: String
	var node: Node2D

class WinnerDetails extends Resource:
	var winning_tiles: Array
	var is_winner: bool
