extends Node2D

@export var allegiance: int
@export var spawnee: PackedScene

func spawn():
	var object = spawnee.instantiate()
	object.global_position = global_position + Vector2(randf_range(-5.0, 5.0), randf_range(-5.0, 5.0))
	object.allegiance = allegiance
	get_tree().current_scene.add_child(object)
