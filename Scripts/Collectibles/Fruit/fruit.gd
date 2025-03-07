extends Area2D

var isFruitCollected = false
@onready var player = get_node(^"../../../Player/CharacterBody2D")

func _on_body_entered(node) -> void:
	if node == player:
		node.get_parent().fruitCount += 1
		print("Player fruit count = ", node.get_parent().fruitCount)
		node.get_parent().maxStamina += 10
		node.get_parent().staminaRecovery()
		get_parent().queue_free()
