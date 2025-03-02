extends Node2D

@onready var pauseMenu = $"UI/CanvasLayer/PauseMenu"
@onready var player = $"Player"
@onready var fruits = $"Fruits"
@onready var coins = $"Coins"
@onready var checkpoints = $"Checkpoints"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("PauseOrExit") && pauseMenu.modulate.a < 0.5:
		player.process_mode = Node.PROCESS_MODE_DISABLED
		fruits.process_mode = Node.PROCESS_MODE_DISABLED
		coins.process_mode = Node.PROCESS_MODE_DISABLED
		checkpoints.process_mode = Node.PROCESS_MODE_DISABLED
		pauseMenu.modulate = Color(1, 1, 1, 1)
		print("Game has been paused.")
	elif Input.is_action_just_pressed("PauseOrExit") && pauseMenu.modulate.a > 0.5:
		player.process_mode = Node.PROCESS_MODE_INHERIT
		fruits.process_mode = Node.PROCESS_MODE_INHERIT
		coins.process_mode = Node.PROCESS_MODE_INHERIT
		checkpoints.process_mode = Node.PROCESS_MODE_INHERIT
		pauseMenu.modulate = Color(1, 1, 1, 0)
		print("Game has been unpaused.")
