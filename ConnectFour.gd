extends Node2D


var tile_size = 64
@export var GameSize = Vector2i(3, 6)
var x_movement: int
var y_movement
@onready var GamePiecePreload := preload("res://game_piece.tscn")
@onready var PlayArea: CollisionShape2D = $GameBoard/PlayArea
@onready var UserTurnLabel: Label = $"../UI/UsersTurnLabel"

@export var InARowToWin: int
@export var Player1: String
@export var Player2: String
@export var Player1Color: Color
@export var Player2Color: Color


var CurrentPlayersTurn: String

var inputs = {"right": Vector2.RIGHT,}

var game_positions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	CurrentPlayersTurn = Player1
	UserTurnLabel.text = "Current Players Turn: " + CurrentPlayersTurn
	for x in range(GameSize.x):
		game_positions.append([])
		game_positions[x] = []
		for y in range(GameSize.y):
			game_positions[x].append([])
			var details = C4Structs.MatrixDetails.new()
			game_positions[x][y] = details

	
	
func set_icon_size(GamePiece) -> Vector2:

	x_movement = PlayArea.shape.get_rect().size.x / GameSize.x
	y_movement = PlayArea.shape.get_rect().size.y / GameSize.y
	var grid_size: = Vector2(x_movement, y_movement)
	var new_scale = grid_size / GamePiece.get_node("Icon").get_rect().size
	GamePiece.scale = new_scale

	return grid_size



func _on_game_board_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("place_piece"):
		var game_piece: Node2D = GamePiecePreload.instantiate()
		
		var grid_size := set_icon_size(game_piece)
		var x_position := calculate_x_position(event, grid_size)
		
		var y_position = calculate_y_position(grid_size, x_position)
		
		game_piece.position = Vector2(x_position.position, y_position.position)
		if y_position.is_valid:
			var color = get_players_color()
			switch_players_turn()
			game_piece.get_node("Icon").modulate = color
			self.add_child(game_piece)
			game_positions[x_position.index][GameSize.y - y_position.index].node = game_piece
			check_for_winner()
		
	


func check_for_winner():
	var winning_details := check_for_winner_on_x()

	if winning_details.is_winner:
		print(winning_details.winning_tiles)
		color_winning_tiles(winning_details)

	winning_details = check_for_winner_on_y()
	if winning_details.is_winner:
		print(winning_details.winning_tiles)
		color_winning_tiles(winning_details)
		
	winning_details = check_for_winner_diagnol_down()
	if winning_details.is_winner:
		print(winning_details.winning_tiles)
		color_winning_tiles(winning_details)
		
	winning_details = check_for_winner_diagnol_up()
	if winning_details.is_winner:
		print(winning_details.winning_tiles)
		color_winning_tiles(winning_details)
		
func check_for_winner_diagnol_down() -> C4Structs.WinnerDetails:
	var is_winner := false
	var player_in_spot: String = ""
	var current_in_a_row: int = 0
	var winning_tiles = []
	
	for x in range(GameSize.y):
		if is_winner:
			break
			
		for y in range(GameSize.x):
			if is_winner:
				break
				
			var current_spot_player = game_positions[y][x].player_name
			if Objects.is_empty(current_spot_player):
				continue
				
			winning_tiles = []
			winning_tiles.append(Vector2(y,x))
			player_in_spot = current_spot_player
			current_in_a_row = 0
			
			var y_prime = y
			var x_prime = x
			
			
			while y_prime < GameSize.x and x_prime >= 0:

				current_spot_player = game_positions[y_prime][x_prime].player_name
				
				if Objects.is_empty(current_spot_player):
					break	
				if current_spot_player == player_in_spot:
					current_in_a_row += 1
				else:
					player_in_spot = current_spot_player
					current_in_a_row = 1
					winning_tiles = []
					
				winning_tiles.append(Vector2(y_prime, x_prime))
					
				if current_in_a_row >= InARowToWin:
					is_winner = true
					break
				x_prime -= 1
				y_prime += 1
				
	var winning_details := C4Structs.WinnerDetails.new()
	winning_details.is_winner = is_winner
	winning_details.winning_tiles = winning_tiles
	return winning_details
		
func check_for_winner_diagnol_up() -> C4Structs.WinnerDetails:
	var is_winner := false
	var player_in_spot: String = ""
	var current_in_a_row: int = 0
	var winning_tiles = []
	
	for x in range(GameSize.y):
		if is_winner:
			break
			
		for y in range(GameSize.x):
			if is_winner:
				break
				
			var current_spot_player = game_positions[y][x].player_name
			if Objects.is_empty(current_spot_player):
				continue
				
			winning_tiles = []
			winning_tiles.append(Vector2(y,x))
			player_in_spot = current_spot_player
			current_in_a_row = 0
			
			var y_prime = y
			var x_prime = x
			
			
			while y_prime < GameSize.x and x_prime < GameSize.y:

				current_spot_player = game_positions[y_prime][x_prime].player_name
				
				if Objects.is_empty(current_spot_player):
					break	
				if current_spot_player == player_in_spot:
					current_in_a_row += 1
				else:
					player_in_spot = current_spot_player
					current_in_a_row = 1
					winning_tiles = []
					
				winning_tiles.append(Vector2(y_prime, x_prime))
					
				if current_in_a_row >= InARowToWin:
					is_winner = true
					break
				x_prime += 1
				y_prime += 1
				
	var winning_details := C4Structs.WinnerDetails.new()
	winning_details.is_winner = is_winner
	winning_details.winning_tiles = winning_tiles
	return winning_details
	
	
func check_for_winner_on_x() -> C4Structs.WinnerDetails:
	var is_winner := false
	var player_in_spot: String = ""
	var current_in_a_row: int = 0
	var winning_tiles = []
	
	for x in range(GameSize.y):
		if is_winner:
			break
			
		winning_tiles = []
		player_in_spot = ""
		current_in_a_row = 0
			
		for y in range(GameSize.x):
			var current_spot_player = game_positions[y][x].player_name
			if Objects.is_empty(current_spot_player):
				current_in_a_row = 0
				winning_tiles = []
				continue
				
			if current_spot_player == player_in_spot:
				current_in_a_row += 1
			else:
				player_in_spot = current_spot_player
				current_in_a_row = 1
				winning_tiles = []
				
			winning_tiles.append(Vector2(y, x))
				
			if current_in_a_row >= InARowToWin:
				is_winner = true
				break
				
	var winning_details := C4Structs.WinnerDetails.new()
	winning_details.is_winner = is_winner
	winning_details.winning_tiles = winning_tiles
	return winning_details

func color_winning_tiles(winning_details: C4Structs.WinnerDetails):
	for node_coordinates in winning_details.winning_tiles:
		var node_at_position = game_positions[node_coordinates.x][node_coordinates.y].node
		node_at_position.get_node("Icon").modulate = Color.GOLD
	
	
func check_for_winner_on_y() -> C4Structs.WinnerDetails:
	var is_winner := false
	var player_in_spot: String = ""
	var current_in_a_row: int = 0
	var winning_tiles = []
	for x in range(game_positions.size()):
		if is_winner:
			break
			
		winning_tiles = []
		player_in_spot = ""
		current_in_a_row = 0
			
		for y in range(game_positions[x].size()):
			var current_spot_player = game_positions[x][y].player_name
			if Objects.is_empty(current_spot_player):
				current_in_a_row = 0
				winning_tiles = []
				continue
				
			if current_spot_player == player_in_spot:
				current_in_a_row += 1
			else:
				player_in_spot = current_spot_player
				current_in_a_row = 1
				winning_tiles = []
				
			winning_tiles.append(Vector2(x, y))
				
			if current_in_a_row >= InARowToWin:
				is_winner = true
				break
				
	var winning_details := C4Structs.WinnerDetails.new()
	winning_details.is_winner = is_winner
	winning_details.winning_tiles = winning_tiles
	return winning_details
				
func calculate_y_position(grid_size: Vector2, position_details: C4Structs.PositionDetails) -> C4Structs.PositionDetails:
	var size := PlayArea.shape.get_rect().size
	var bottom_edge = PlayArea.position.y - (size.y / 2)
	
	var position_array := []

	
	for i in range(GameSize.y):
		position_array.push_back(bottom_edge + (i * size.y / GameSize.y))
		
	var y_index = 112
	var is_valid = false
		
	for y in range(game_positions[position_details.index].size()):
		var details: C4Structs.MatrixDetails = game_positions[position_details.index][y]
		
		if Objects.is_empty(details.player_name):
			y_index = y
			is_valid = true
			details.player_name = CurrentPlayersTurn
			game_positions[position_details.index][y] = details
			break
			
	y_index = GameSize.y - y_index
			
	var y_position = (grid_size * (y_index)).y - (grid_size.y / 2) + bottom_edge
			
	var y_position_details := C4Structs.PositionDetails.new()
	y_position_details.is_valid = is_valid
	y_position_details.index = y_index
	y_position_details.position = y_position

	
	
	return y_position_details
	

func calculate_x_position(event: InputEvent, grid_size: Vector2) -> C4Structs.PositionDetails:
	var size := PlayArea.shape.get_rect().size
	var left_edge = PlayArea.position.x - (size.x / 2)

	
	var position_array := []

	
	for i in range(GameSize.x):
		position_array.push_back(left_edge + (i * size.x / GameSize.x))
	
	var x_index = 0
	for i in range(position_array.size()):
		if i == position_array.size() - 1:
			x_index = i
			break
		elif event.position.x >= position_array[i] and event.position.x <= position_array[i + 1]:
			x_index = i
			break

	var x_position = (grid_size * (x_index + 1)).x - (grid_size.x / 2) + left_edge
	var position_details := C4Structs.PositionDetails.new()
	position_details.index = x_index
	position_details.position = x_position
	
	
	return position_details

func switch_players_turn():
	var color: Color
	if CurrentPlayersTurn == Player1:
		CurrentPlayersTurn = Player2
	else: 
		CurrentPlayersTurn = Player1

	UserTurnLabel.text = "Current Players Turn: " + CurrentPlayersTurn


func get_players_color() -> Color:
	var color: Color
	if CurrentPlayersTurn == Player1:
		color = Player1Color
	else: 
		color = Player2Color

	return color
