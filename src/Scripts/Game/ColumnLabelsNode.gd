extends Node

func reverse():
	for label in self.get_children():
		label.text = str(9 - int(label.text))
