extends RigidBody2D

@export var movement_speed: float
@export var range: float
@export var ammo: PackedScene

var allegiance: int
var detected_enemies: Dictionary[Node2D, bool] = {}

var target: Node2D:
	set(new_value):
		if new_value != null:
			linear_velocity = Vector2.ZERO
			# start animation if not started
			$AnimationPlayer.play("fire")
		else:
			linear_velocity = movement_dir * movement_speed
			$AnimationPlayer.stop()

var _movement_dir := Vector2.RIGHT
var movement_dir: Vector2:
	set(new_value):
		if new_value.x > 0:
			$FlippyStuff.scale.x = 1.0
		else:
			$FlippyStuff.scale.x = -1.0
		_movement_dir = new_value
	get:
		return _movement_dir

func enemy_dir() -> Vector2:
	if allegiance == 0:
		return Vector2.RIGHT
	else:
		return Vector2.LEFT

func _process(delta: float) -> void:
	var closest_enemy = null
	var closest_offset = Vector2(1e10, 1e10)
	for enemy in detected_enemies:
		var offset = enemy.global_position - global_position
		if offset.length_squared() < closest_offset.length_squared():
			closest_enemy = enemy
			closest_offset = offset
	
	if closest_enemy != null:
		movement_dir = closest_offset.normalized()
		if closest_offset.length() <= range:
			target = closest_enemy
		else:
			target = null
	else:
		movement_dir = enemy_dir()
		target = null

func enemy_detected(unit: Node2D):
	var theirAllegiance = unit.get("allegiance")
	if theirAllegiance != null:
		if allegiance != theirAllegiance:
			detected_enemies[unit] = true

func enemy_lost(unit: Node2D):
	detected_enemies.erase(unit)

func fire():
	var bullet = ammo.instantiate()
	bullet.global_transform = $FlippyStuff/TurretPivot.global_transform
	get_parent().add_child(bullet)
