extends Node2D

@export var allegiance: int
@export var spawnee: PackedScene
@export var goal_direction: Vector2

func spawn():
	var object = spawnee.instantiate()
	object.global_position = global_position + Vector2(randf_range(-5.0, 5.0), randf_range(-5.0, 5.0))
	object.allegiance = allegiance
	object.goal_direction = goal_direction
	get_tree().current_scene.add_child(object)
