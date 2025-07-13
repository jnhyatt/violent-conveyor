extends Node2D

signal food_updated(new_value)

var food: int:
	set(new_value):
		food = new_value
		emit_signal("food_updated", new_value)

func _ready():
	food = 3

func _increment_food():
	food += 1

func _consume_food(count):
	food -= count
