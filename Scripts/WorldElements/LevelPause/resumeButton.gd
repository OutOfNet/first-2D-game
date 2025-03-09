extends Button

@onready var player = $"../../../../Player"
@onready var fruits = $"../../../../Fruits"
@onready var coins = $"../../../../Coins"
@onready var checkpoints = $"../../../../Checkpoints"
@onready var pauseMenu = $"../"

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("PauseOrExit") && pauseMenu.modulate.a == 0:
		grab_focus()

func _on_resumeButton_up() -> void:
	if pauseMenu.modulate.a > 0:
		player.process_mode = Node.PROCESS_MODE_INHERIT
		fruits.process_mode = Node.PROCESS_MODE_INHERIT
		coins.process_mode = Node.PROCESS_MODE_INHERIT
		checkpoints.process_mode = Node.PROCESS_MODE_INHERIT
		pauseMenu.get_node(^"ResumeButton").set_default_cursor_shape(0)
		pauseMenu.get_node(^"ExitButton").set_default_cursor_shape(0)
		pauseMenu.modulate = Color(1, 1, 1, 0)
