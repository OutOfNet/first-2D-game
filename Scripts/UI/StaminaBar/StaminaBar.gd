extends AnimatedSprite2D

@onready var player = get_node(^"../../../Player")
@onready var playerStamina
var timeSinceSprintInput = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x += 1750
	position.y += 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	playerStamina = float(player.stamina)
	var playerMaxStamina = float(player.maxStamina)
	var staminaPercentage = (playerStamina / playerMaxStamina) * 10
	$".".frame = floorf(float(staminaPercentage))
	if player.isSprinting == true and playerStamina < 11:
		$"Polygon2D".color = Color(.2, 1, 1)
	elif player.isSprinting == true and playerStamina > 10:
		$"Polygon2D".color = Color(1, 0.1, 1)
	elif player.isSprinting == false and playerStamina > 2 and playerStamina < 11:
		$"Polygon2D".color = Color(0, 0.3, 0.5)
	elif player.isSprinting == false and playerStamina < 3 and not Input.is_action_just_pressed("sprintInput") and timeSinceSprintInput == 0:
		$"Polygon2D".color = Color(0.2431, 0.2431, 0.2431)
	elif Input.is_action_just_pressed("sprintInput") and playerStamina < 3 and player.isSprinting == false:
		$"Polygon2D".color = Color(0.5, 0.2431, 0.2431)
		timeSinceSprintInput = .2
		await get_tree().create_timer(.2).timeout
		timeSinceSprintInput = 0
	elif player.isSprinting == false and playerStamina > 10:
		$"Polygon2D".color = Color(0.6, 0, 0.8)
