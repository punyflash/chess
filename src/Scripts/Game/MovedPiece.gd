extends Sprite

func set_piece(piece):
	var x = piece % 6
	var y = (piece - x) / 6
	
	self.region_rect.position.x = x * 80
	self.region_rect.position.y = y * 80
