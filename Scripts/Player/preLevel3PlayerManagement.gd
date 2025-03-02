extends Node2D

var currentCheckpoint = Vector2(6, -40)

var health = 100

var speed = 700.0
var jumpVelocity = -1000.0

var fallTime = 0
var hasJumped = true
var isGoingRight
var stamina = 10
var maxStamina = 10.0
var isSprinting = false
var coinCount = 0
var fruitCount = 0
var diedRecently = false
var recoveringStamina = false
var levelEnded = false
var endAnimation = false

@onready var pauseMenu = $"../UI/CanvasLayer/PauseMenu"

func _input(_event: InputEvent) -> void:
	
	# Handles player sprint.
	if Input.is_action_just_pressed("sprintInput") && stamina >= maxStamina * .3 && isSprinting == false && pauseMenu.modulate.a == 0:
		isSprinting = true
		speed = 900
		while stamina > 0 && pauseMenu.modulate.a == 0:
			stamina -= 1
			print(stamina)
			await get_tree().create_timer(.3).timeout
		isSprinting = false
		speed = 700
	
	# Handles player jump.
	if Input.is_action_just_pressed("jumpInput") && fallTime < .15 && hasJumped == false && levelEnded == false && diedRecently == false:
		$"CharacterBody2D".velocity.y = jumpVelocity * 1
		hasJumped = true

func _physics_process(delta: float) -> void:
	
	# Handles stamina recovery
	if stamina < maxStamina && isSprinting == false && recoveringStamina == false && pauseMenu.modulate.a == 0:
		recoveringStamina = true
		await get_tree().create_timer(1.5).timeout
		while stamina < maxStamina && isSprinting == false && levelEnded == false && pauseMenu.modulate.a == 0:
			stamina += maxStamina / 10
			await get_tree().create_timer(.25).timeout
			print("stamina = ", stamina)
		print("stamina recovered fully! ready to sprint again!")
		recoveringStamina = false
	
	
	# If the player's health reaches 0 and the pause menu is closed then the player gets killed.
	if health <= 0 && pauseMenu.modulate.a == 0:
		diedRecently = true
		health = 100
		$"CharacterBody2D".global_position = currentCheckpoint
		print($"CharacterBody2D".global_position)
		$"CharacterBody2D/AnimatedSprite2D".modulate = Color(11, 11, 11, 1)
		await get_tree().create_timer(.5).timeout
		diedRecently = false
		while $"CharacterBody2D/AnimatedSprite2D".modulate.r > 1:
			$"CharacterBody2D/AnimatedSprite2D".modulate.r -= modulate.r / 2
			$"CharacterBody2D/AnimatedSprite2D".modulate.g -= modulate.g / 2
			$"CharacterBody2D/AnimatedSprite2D".modulate.b -= modulate.b / 2
			await get_tree().create_timer(2.5/21).timeout
		print($"CharacterBody2D/AnimatedSprite2D".modulate)
	
	# Add the gravity.
	if not $"CharacterBody2D".is_on_floor():
		$"CharacterBody2D".velocity += $"CharacterBody2D".get_gravity() * delta
		if isSprinting == false:
			$"CharacterBody2D/AnimatedSprite2D".play("MidAir")
		else:
			$"CharacterBody2D/AnimatedSprite2D".play("sprintMidAir")
		fallTime += 1 * delta
	else:
		fallTime = 0
		hasJumped = false
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("leftInput", "rightInput")
	if direction && not diedRecently:
		$"CharacterBody2D".velocity.x = direction * speed
		if $"CharacterBody2D".velocity.x > 0:
			isGoingRight = false
		elif $"CharacterBody2D".velocity.x < 0:
			isGoingRight = true
		if isSprinting == false && $"CharacterBody2D".is_on_floor():
			$"CharacterBody2D/AnimatedSprite2D".play("Run")
		elif isSprinting == true && $"CharacterBody2D".is_on_floor():
			$"CharacterBody2D/AnimatedSprite2D".play("sprintRun")
		$"CharacterBody2D/AnimatedSprite2D".set_flip_h(isGoingRight)
	else:
		$"CharacterBody2D".velocity.x = move_toward($"CharacterBody2D".velocity.x, 0, speed)
		if isSprinting == false && $"CharacterBody2D".is_on_floor() && levelEnded == false:
			$"CharacterBody2D/AnimatedSprite2D".play("Idle")
		elif isSprinting == true && $"CharacterBody2D".is_on_floor() && levelEnded == false:
			$"CharacterBody2D/AnimatedSprite2D".play("sprintIdle")
	
	if levelEnded == true && endAnimation == false:
		endAnimation = true
		$"CharacterBody2D/AnimatedSprite2D".play("LevelEnd")

	$"CharacterBody2D".move_and_slide()
