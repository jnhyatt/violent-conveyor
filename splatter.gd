extends Sprite2D

@export var splatters: Array[Texture2D]

func _ready():
	texture = splatters.pick_random()
	$AnimationPlayer.play("fade_out")
