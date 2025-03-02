extends Button

func _on_button_up() -> void:
	$"../Loading".modulate.a = 1
	await get_tree().create_timer(.05).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/secondLevel.tscn")
