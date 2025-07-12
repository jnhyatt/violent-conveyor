extends RigidBody2D

@export var movement_speed: float
var allegiance: int
# This is a set... ignore the value, gdscript doesn't have a unit type I guess
var in_range_enemies: Dictionary[Node2D, bool] = {}
var goal_direction: Vector2

func _ready():
	update_targeting()

func _entered_range(unit):
	var theirAllegiance = unit.get("allegiance")
	if theirAllegiance != null:
		if allegiance != theirAllegiance:
			in_range_enemies[unit] = true
	update_targeting()
	print(name + " enemies: " + str(in_range_enemies))

func _exited_range(unit):
	in_range_enemies.erase(unit)
	update_targeting()

func update_targeting():
	var closest_enemy = null
	var closest_distance = 1e10
	for enemy in in_range_enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest_distance:
			closest_distance = dist
			closest_enemy = enemy
	
	if closest_enemy:
		linear_velocity = Vector2.ZERO
	else:
		linear_velocity = goal_direction * movement_speed
