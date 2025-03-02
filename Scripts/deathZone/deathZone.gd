extends Node

@onready var player = $"../../../Player/CharacterBody2D"

func _on_body_entered(node) -> void:
	if node == player:
		node.get_parent().health = 0
		print("Player has fallen in the void")
