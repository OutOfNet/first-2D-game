extends Button

func _on_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/LevelSelect.tscn")

func _ready() -> void:
	$".".grab_focus()
