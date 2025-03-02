extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("PauseOrExit"):
		get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/MainMenu.tscn")
