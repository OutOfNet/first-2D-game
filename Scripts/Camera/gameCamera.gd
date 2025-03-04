extends Camera2D

var player
var isPlayerSprinting

func cameraZoomModify() -> void:
	# Zooms out when the player sprints.
	if isPlayerSprinting == true:
		while zoom > Vector2(1, 1) && isPlayerSprinting == true:
			if zoom.x - 1 < 0.0001:
				zoom = Vector2(1, 1)
			else:
				zoom -= (zoom - Vector2(1, 1)) / 8
				await get_tree().create_timer(.01).timeout
	
	# Zooms back in when the player stops sprinting.
	elif isPlayerSprinting == false:
		while zoom < Vector2(1.15, 1.15) && isPlayerSprinting == false:
			if 1.15 - zoom.x < 0.0001 && player.levelEnded == false:
				zoom = Vector2(1.15, 1.15)
			elif player.levelEnded == false:
				zoom += (Vector2(1.15, 1.15) - zoom) / 8
				await get_tree().create_timer(.01).timeout

func _ready() -> void:
	player = get_node(^"../../Player")

func _process(_delta: float) -> void:
	# Checks whether or not the player is sprinting.
	isPlayerSprinting = player.isSprinting
	
	# Makes the camera follow the player.
	position.x = $"../../Player/CharacterBody2D".position.x * 3
	position.y = $"../../Player/CharacterBody2D".position.y * 3
