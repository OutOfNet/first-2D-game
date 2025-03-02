extends Area2D

var isChekpointCollected = false
@onready var player = get_node(^"../../../Player/CharacterBody2D")

func _on_body_entered(node) -> void:
	
	if node == player:
		node.get_parent().currentCheckpoint = global_position
		print("Current checkpoint = ", node.get_parent().currentCheckpoint)
	
		if isChekpointCollected == false:
		
			isChekpointCollected = true
			$"../AnimatedSprite2D".frame = 0
			$"../AnimatedSprite2D".stop()
			for i in range(1, 5):
				$"../AnimatedSprite2D".scale += (Vector2(2, 2) - $"../AnimatedSprite2D".scale) / 8 + Vector2(.0001, .0001)
				await get_tree().create_timer(.025).timeout
			for i in range(1, 5):
				$"../AnimatedSprite2D".scale -= (Vector2(2, 2) - $"../AnimatedSprite2D".scale) / 8 + Vector2(.0001, .0001)
				await get_tree().create_timer(.025).timeout
			
			$"../AnimatedSprite2D".play()
			
			for i in range(1, 40):
				$"../AnimatedSprite2D".position.y -= ($"../AnimatedSprite2D".position.y + 12.5) / 4
				$"../AnimatedSprite2D".self_modulate -= Color(0, 0, 0, .05)
				await get_tree().create_timer(.025).timeout
		
			print("Checkpoint collected, initiating vanishing.")
			get_parent().queue_free()
