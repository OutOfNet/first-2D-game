extends Camera2D

var player
var isPlayerSprinting

func cameraZoomModify() -> void:
	# Zooms out when the player sprints.
	if isPlayerSprinting == true:
		while zoom > Vector2(0.5, 0.5) && isPlayerSprinting == true && player.levelEnded == false:
			if zoom.x - 0.5 < 0.0001 && player.levelEnded == false:
				zoom = Vector2(0.5, 0.5)
			elif player.levelEnded == false:
				zoom -= (zoom - Vector2(0.5, 0.5)) / 8
				await get_tree().create_timer(.01).timeout
	
	# Zooms back in when the player stops sprinting.
	elif isPlayerSprinting == false or player.levelEnded:
		while zoom < Vector2(0.6, 0.6) && isPlayerSprinting == false && player.levelEnded == false:
			if 0.6 - zoom.x < 0.0001 && player.levelEnded == false:
				zoom = Vector2(0.6, 0.6)
			elif player.levelEnded == false && player.levelEnded == false:
				zoom += (Vector2(0.6, 0.6) - zoom) / 8
				await get_tree().create_timer(.01).timeout

func _ready() -> void:
	player = get_node(^"../../Player")

func _process(_delta: float) -> void:
	# Checks whether or not the player is sprinting.
	isPlayerSprinting = player.isSprinting
	
	# Makes the camera follow the player.
	position.x = $"../../Player/CharacterBody2D".position.x * 3
	position.y = $"../../Player/CharacterBody2D".position.y * 3
