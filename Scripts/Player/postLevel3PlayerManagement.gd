extends Node2D

var currentCheckpoint = Vector2(6, -40)

var health = 100

var speed = 700.0
var jumpVelocity = -1000.0

var fallTime = 0
var hasJumped = true
var stamina = 10
var maxStamina = 10.0
var isSprinting = false
var coinCount = 0
var fruitCount = 0
var diedRecently = false
var recoveringStamina = false
var levelEnded = false
var endAnimation = false
var sprintDuration = 0

@onready var pauseMenu = $"../UI/CanvasLayer/PauseMenu"

func sprintInterrupt() -> void:
	print("Sprinting stopped.")
	sprintDuration = 0
	speed = 700

func staminaRecovery() -> void:
	# Handles stamina recovery
	if stamina < maxStamina && isSprinting == false && recoveringStamina == false && pauseMenu.modulate.a == 0 && levelEnded == false:
		recoveringStamina = true
		await get_tree().create_timer(1.5).timeout
		while stamina < maxStamina && isSprinting == false && levelEnded == false && pauseMenu.modulate.a == 0 && levelEnded == false:
			stamina += maxStamina / 10
			await get_tree().create_timer(.25).timeout
			print("stamina = ", stamina)
		if stamina > maxStamina:
			stamina = maxStamina
		print("stamina recovered fully! ready to sprint again!")
		recoveringStamina = false
	elif levelEnded == false:
		await get_tree().create_timer(.25).timeout
		staminaRecovery()

func _input(_event: InputEvent) -> void:
	
	# Handles player sprint.
	if Input.is_action_just_pressed("sprintInput") && stamina >= maxStamina * .3 && isSprinting == false && pauseMenu.modulate.a == 0:
		isSprinting = true
		await get_tree().create_timer(.005).timeout
		$"../UI/Camera2D".cameraZoomModify()
		speed = 900
		while stamina > 0 && pauseMenu.modulate.a == 0:
			sprintDuration += 2 * get_process_delta_time()
			print("   Sprint duration : ", sprintDuration)
			if Input.is_action_just_pressed("sprintInput") && pauseMenu.modulate.a == 0 && sprintDuration > 1 && speed == 900 && levelEnded == false:
				sprintInterrupt()
				await get_tree().create_timer(.005).timeout
				$"../UI/Camera2D".cameraZoomModify()
				break
			stamina -= 7 * get_process_delta_time()
			print(stamina)
			await get_tree().create_timer(.03).timeout
		isSprinting = false
		if stamina < 0:
			stamina = 0
		await get_tree().create_timer(.005).timeout
		$"../UI/Camera2D".cameraZoomModify()
		speed = 700
		sprintDuration = 0
		staminaRecovery()
	
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
	if (not $"CharacterBody2D".is_on_floor() && not $"CharacterBody2D".is_on_ceiling()) or ($"CharacterBody2D".is_on_ceiling() && isSprinting == false):
		if isSprinting == false:
			$"CharacterBody2D".velocity += $"CharacterBody2D".get_gravity() * delta
			$"CharacterBody2D".scale.y = 1
			if isSprinting == false:
				$"CharacterBody2D/AnimatedSprite2D".play("MidAir")
			else:
				$"CharacterBody2D/AnimatedSprite2D".play("sprintMidAir")
		else:
			$"CharacterBody2D/AnimatedSprite2D".play("sprintMidAir")
			$"CharacterBody2D".velocity -= $"CharacterBody2D".get_gravity() * delta
			$"CharacterBody2D".scale.y = -1
		fallTime += 1 * delta
	elif $"CharacterBody2D".is_on_floor() && isSprinting == true:
		$"CharacterBody2D".velocity -= $"CharacterBody2D".get_gravity() * delta
		$"CharacterBody2D".scale.y = -1
	else:
		fallTime = 0
		hasJumped = false
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("leftInput", "rightInput")
	if direction && not diedRecently:
		$"CharacterBody2D".velocity.x = direction * speed
		if $"CharacterBody2D".velocity.x > 0:
			$"CharacterBody2D/AnimatedSprite2D".set_flip_h(0)
		elif $"CharacterBody2D".velocity.x < 0:
			$"CharacterBody2D/AnimatedSprite2D".set_flip_h(1)
		if isSprinting == false && $"CharacterBody2D".is_on_floor():
			$"CharacterBody2D/AnimatedSprite2D".play("Run")
		elif isSprinting == true && ($"CharacterBody2D".is_on_floor() or $"CharacterBody2D".is_on_ceiling()):
			$"CharacterBody2D/AnimatedSprite2D".play("sprintRun")
	else:
		$"CharacterBody2D".velocity.x = move_toward($"CharacterBody2D".velocity.x, 0, speed)
		if isSprinting == false && ($"CharacterBody2D".is_on_floor() or $"CharacterBody2D".is_on_ceiling()) && levelEnded == false:
			$"CharacterBody2D/AnimatedSprite2D".play("Idle")
		elif isSprinting == true && ($"CharacterBody2D".is_on_floor() or $"CharacterBody2D".is_on_ceiling()) && levelEnded == false:
			$"CharacterBody2D/AnimatedSprite2D".play("sprintIdle")

	$"CharacterBody2D".move_and_slide()
