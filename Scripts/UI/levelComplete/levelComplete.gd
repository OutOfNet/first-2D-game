extends Label

@onready var player = get_node(^"../../../Player")
var levelEndAnimationPlaying = false

func _ready() -> void:
	position = Vector2(810, 450)

func _process(_delta: float) -> void:
	if player.levelEnded == true && levelEndAnimationPlaying == false:
		levelEndAnimationPlaying = true
		for i in range(1, 20):
			$".".self_modulate += Color(0, 0, 0, .05)
			await get_tree().create_timer(.05).timeout
