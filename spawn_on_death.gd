extends Node

@export var spawnees: Array[PackedScene]

func _ready():
	get_parent().connect("tree_exiting", Callable(self, "_on_parent_exiting"))

func _on_parent_exiting():
	for spawnee in spawnees:
		var object = spawnee.instantiate()
		object.global_position = get_parent().global_position
		get_parent().get_parent().add_child.call_deferred(object)
