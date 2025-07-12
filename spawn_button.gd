extends Button

@export var cost: int

func _ready():
	get_tree().root.get_node("Node2D").connect("food_updated", Callable(self, "_on_food_updated"))
	connect("pressed", func(): get_tree().root.get_node("Node2D")._consume_food(cost))

func _on_food_updated(new_value):
	disabled = new_value < cost
