extends Resource
class_name materials

@export var lumber : int = 0
@export var stone : int = 0

func gain_lumber(amount):
	lumber += amount
	pass

func gain_stone(amount):
	stone += amount
	pass
