var GameplayEngine = preload("res://src/Game/GameplayEngine.gd")
var Move = preload("res://src/Game/Pieces/Move.gd")

enum Direction {UP = 8, DOWN = -8, LEFT = -1, RIGHT = 1}

class Piece:
	func get_moves(engine):
		return null

	func is_valid_move(move):
