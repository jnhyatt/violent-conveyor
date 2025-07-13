extends RigidBody2D

@export var speed: float
var allegiance: int

func _ready():
	linear_velocity = global_transform.x * speed


func _on_collider_area_area_entered(area: Area2D) -> void:
	print("area entered " + str(area))
