extends RigidBody2D
class_name Tank

enum FireState {
	Warmup,
	Cooldown,
}

@export var movement_speed: float
@export var range: float
@export var ammo: PackedScene
@export var max_hp: float
@export var fire_state := FireState.Warmup

var allegiance: int
var detected_enemies: Dictionary[Node2D, bool] = {}
var _hp: float
var hp: float:
	set(new_value):
		$ProgressBar.value = new_value
		_hp = new_value
		if new_value <= 0:
			queue_free()
	get:
		return _hp

var target: Node2D:
	set(new_value):
		if new_value != null:
			linear_velocity = Vector2.ZERO
			$FlippyStuff/TurretPivot.global_rotation = movement_dir.angle()
			if not $AnimationPlayer.is_playing():
				$AnimationPlayer.play("fire")
		else:
			linear_velocity = movement_dir * movement_speed
			$FlippyStuff/TurretPivot.rotation = 0
			if fire_state == FireState.Warmup:
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

func _ready() -> void:
	hp = max_hp
	$ProgressBar.max_value = max_hp

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
	var their_allegiance = unit.get("allegiance")
	if their_allegiance != null:
		if allegiance != their_allegiance:
			detected_enemies[unit] = true

func enemy_lost(unit: Node2D):
	detected_enemies.erase(unit)

func fire():
	var bullet = ammo.instantiate() as Projectile
	bullet.global_transform = $FlippyStuff/TurretPivot.global_transform
	bullet.allegiance = allegiance
	get_parent().add_child(bullet)

func deal_damage(amount: float) -> void:
	hp -= amount
