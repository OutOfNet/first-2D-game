extends Node2D

var isCoinCollected = false
@onready var player = get_node(^"../../../Player/CharacterBody2D")

func _on_body_entered(node) -> void:
	if node == player:
		node.get_parent().coinCount += 1
		print("Coin count = ", node.get_parent().coinCount)
		get_parent().queue_free()
