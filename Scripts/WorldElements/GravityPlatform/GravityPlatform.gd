extends Node2D

var player

func _ready() -> void:
	player = $"../../../Player"

func _input(_event) -> void:
	if player.isSprinting == true:
		$"CollisionShape2D/AnimatedSprite2D".play("GripWallEnabled")
	else:
		$"CollisionShape2D/AnimatedSprite2D".play("GripWallDisabled")
