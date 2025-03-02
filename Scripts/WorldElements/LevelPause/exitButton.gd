extends Button

@onready var pauseMenu = $"../"

func _on_exitButton_up() -> void:
	if pauseMenu.modulate.a > 0:
		get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/MainMenu.tscn")
