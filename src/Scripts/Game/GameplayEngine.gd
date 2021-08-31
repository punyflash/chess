enum PlayerColor { WHITE = 0, BLACK = 6 }
enum Piece { KING, QUEEN, BISHOP, KNIGHT, ROOK, PAWN }
enum Castle { W_LONG, W_SHORT, B_LONG, B_SHORT }

# Game state
var board = {}
var move = PlayerColor.WHITE
var castles = [Castle.W_LONG, Castle.W_SHORT, Castle.B_LONG, Castle.B_SHORT]
var en_passant = null
var halfmove_clock = 0
var fullmove_number = 0

func _init(fen: String):
	loadFen(fen)

func loadFen(fen: String):
	self.board = {}
	self.castles = []
	var cord = Vector2(0, 7)
	var fenDecode = {
		"k": Piece.KING, "p": Piece.PAWN, "n": Piece.KNIGHT,
		"b": Piece.BISHOP, "r": Piece.ROOK, "q": Piece.QUEEN
	}

	var parts = fen.split(' ')

	# Piece position
	for ch in parts[0]:
		var int_ch = ch.to_int()

		if ch == '/':
			cord.x = 0
			cord.y -= 1
			continue

		if int_ch:
			cord.x += int_ch
			continue

		var color = PlayerColor.BLACK if ch.to_ascii()[0] >= 97 else PlayerColor.WHITE
		var piece = fenDecode[ch.to_lower()]
		self.board[int(cord.y * 8 + cord.x)] = color + piece
		cord.x += 1

	# Next to move
	self.move = PlayerColor.WHITE if parts[1] == 'w' else PlayerColor.BLACK
	
	# Castling
	for ch in parts[2]:
		if ch == 'K': self.castles.push_back(Castle.B_SHORT)
		if ch == 'k': self.castles.push_back(Castle.W_SHORT)
		if ch == 'Q': self.castles.push_back(Castle.B_LONG)
		if ch == 'q': self.castles.push_back(Castle.W_LONG)

	# En passant
	self.en_passant = null if parts[3] == '-' else notationToCell(parts[3])
	
	# Halfmoves clock
	self.halfmove_clock = int(parts[4])
	
	# Fullmove number
	self.fullmove_number = int(parts[5])

func notationToCell(position: String):
	var translate = {
		"a": 1, "b": 2, "c": 3, "d": 4,
		"e": 5, "f": 6, "g": 7, "h": 8
	}
	return (int(translate[position[0]]) - 1) * 8 + int(position[1])

func make_move(from: int, to: int):
	# Update board
	var piece = board[from]
	board.erase(from)
	board[to] = piece
	
	# Update turn
	move = PlayerColor.WHITE if move == PlayerColor.BLACK else PlayerColor.BLACK
	
	# Halfturns counter
	# TODO: check for count conditions
	if true:
		halfmove_clock += 1
	
	# Update turn counter
	if move == PlayerColor.WHITE:
		fullmove_number += 1
