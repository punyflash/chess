extends Node2D
class_name Board

const GameplayEngine := preload("res://src/Scripts/Game/GameplayEngine.gd")

var engine = GameplayEngine.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
var view = GameplayEngine.PlayerColor.WHITE

# Mouse hooks
var dragged = null
var selected = null

# func _ready():
# 	self.set_view(GameplayEngine.PlayerColor.BLACK)

func set_view(view):
	if (view != self.view):
		$ColumnLabelsNode.reverse()
		$RowLabelsNode.reverse()
	self.view = view

func positionToCell(position: int):
	var x = position % 8
	var y = (position - x) / 8
	
	return Vector2(x, 7 - y) if self.view == GameplayEngine.PlayerColor.WHITE else Vector2(7 - x, y)

func cellToPosition(position: Vector2):
	if self.view == GameplayEngine.PlayerColor.WHITE:
		position.y = 7 - position.y
	if self.view == GameplayEngine.PlayerColor.BLACK:
		position.x = 7 - position.x
	
	return int(position.y * 8 + position.x)

func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		drag($Board.world_to_map(event.position))
	
	if event is InputEventMouseButton && !event.is_pressed():
		drop($Board.world_to_map(event.position))

	update()

func _draw():
	$Board.clear()
	$Selection.clear()

	var pieces = {
		GameplayEngine.Piece.KING: 'King',
		GameplayEngine.Piece.QUEEN: 'Queen',
		GameplayEngine.Piece.KNIGHT: 'Knight',
		GameplayEngine.Piece.BISHOP: 'Bishop',
		GameplayEngine.Piece.ROOK: 'Rook',
		GameplayEngine.Piece.PAWN: 'Pawn',
	}
	
	for key in engine.board.keys():
		var value = engine.board[key]
		if key == dragged:
			$Board/MovedPiece.set_piece(value)
			continue
		var piece = 'W'
		if value >= 6:
			piece = 'B'
			value -= 6
		piece = $Board.tile_set.find_tile_by_name(piece + pieces[value])

		var cell = positionToCell(key)
		$Board.set_cell(cell.x, cell.y, piece)
	
	if dragged:
		$Board/MovedPiece.visible = true
		$Board/MovedPiece.position = get_viewport().get_mouse_position()
	else:
		$Board/MovedPiece.visible = false
		
	
	var select = $Selection.tile_set.find_tile_by_name('Selected')
	if dragged:
		var cell = positionToCell(dragged)
		$Selection.set_cell(cell.x, cell.y, select)
		
	if selected:
		var cell = positionToCell(selected)
		$Selection.set_cell(cell.x, cell.y, select)

func drag(position: Vector2):
	var cell = cellToPosition(position)
	if engine.board.has(cell):
		dragged = cell
	if selected != null && selected != dragged:
		return make_move(selected, cell)
	
	
func drop(position: Vector2):
	var cell = cellToPosition(position)
	if dragged == cell:
		selected = cell if selected != cell else null
		dragged = null
		return
	if dragged != null:
		return make_move(dragged, cell)

func make_move(from: int, to: int):
	engine.make_move(from, to)
	selected = null
	dragged = null
