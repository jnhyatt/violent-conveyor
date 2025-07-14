extends RigidBody2D
class_name Projectile

@export var speed: float
@export var damage: float
@export var range: float
var allegiance: int

func _ready():
	$Timer.start(range / speed)
	linear_velocity = global_transform.x * speed

func on_hit(body: Node2D) -> void:
	var tank := body as Tank
	if tank == null:
		return
	if tank.allegiance != allegiance:
		tank.deal_damage(damage)
		queue_free()
