extends Area2D

@onready var player = $"../../Player/CharacterBody2D"

func _on_body_entered(body) -> void:
	if body == player && player.get_parent().diedRecently == false:
		player.get_parent().diedRecently = true
		player.get_node(^"AnimatedSprite2D").play("Idle")
		await get_tree().create_timer(1).timeout
		player.get_parent().levelEnded = true
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/MainMenu.tscn")
