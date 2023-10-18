
extends CharacterBody2D

var canFire = true # true if allowed to shoot
var canJump = true # true if allowed to input jump. Planning on using this for air dashing / jump
var isMoving = false # true if player has an x vel and is alive
var isJumping = false # True if player has y vel and is alive
var aimingMid = false
var aimingHigh = false
var hasMachineGun = false
var machineGunAmmo : int = 0
var alive : bool = true # if player alive
var wentUp : bool = false # On death, this is when the player is going upward
var postDeathInvuln : bool = false # triggers post death invuln when we turn alive back to true
var deathInvulnCounter : int = 0 # Timer for how long to flicker the sprite
var deathTimeInvuln: int = 180 # amount of time player is invuln after death
var bullet = preload ("res://playerbullet.tscn") # Preload the bullet scene
var bulletMG = preload ("res://playerbulletMG.tscn") # Preload the MG bullet scene

@onready var state_machine = $AnimationTree["parameters/playback"]
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_player : AnimationPlayer = $AnimationPlayer


@export var fireRate = .4   # Fire rate for pistol (default)
@export var fireRateMG = .1 # Fire rate for the machine gun
@export var jumpRate = .6   # Jump speed
@export var moveSpeed : float = 85 # movement speed left / right
@export var jumpForce : float = 200 # propulsion for upward movement of jump
@export var gravity : float = 900 # simulated gravity to drag player back down

func _ready():
	animation_tree.active = true # This turns on the animations, I have them set to off in the editor UI

func _process(_delta):
	
	
	
	if postDeathInvuln:
		
		visible = randi_range(0,1) # This flickers the sprite back and forth to make a fade out illusion
		$Body.disabled = 1
		deathInvulnCounter += 1
		print(deathInvulnCounter)
		if deathInvulnCounter >= deathTimeInvuln:
			visible = 1
			postDeathInvuln = false
			$Body.disabled = 0
			deathInvulnCounter = 0
	
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and canFire and is_on_floor() and !isMoving and alive:
		if !hasMachineGun:
			var b = bullet.instantiate() # This creates a copy of the scene definied in var bullet above and thus the script for the bullet
			owner.add_child(b)
			b.transform = $shotSpawn.global_transform # Force the bullet to spawn at shotSpawn marker
			canFire = false # Set ability to fire to false, so can't fire
			await get_tree().create_timer(fireRate).timeout # This waits to execute the next line. Adjust variable to be able to fire faster.
			canFire = true # Set fire back to true so can fire again
		elif hasMachineGun:
			var c = bulletMG.instantiate() # This creates a copy of the scene definied in var bullet above and thus the script for the bullet
			owner.add_child(c)
			c.transform = $shotSpawn.global_transform # Force the bullet to spawn at shotSpawn marker
			canFire = false # Set ability to fire to false, so can't fire
			await get_tree().create_timer(fireRateMG).timeout # This waits to execute the next line. Adjust variable to be able to fire faster.
			canFire = true # Set fire back to true so can fire again
		
	sprite_animations() # This function handles all of the player animations

func _physics_process(delta):

	velocity.x = 0
	isMoving = false
	
	if is_on_floor() and alive:
		isJumping = false
	
	if !is_on_floor() and alive:
		isJumping = true
		
	if !is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_key_pressed(KEY_A) and alive:
		velocity.x -= moveSpeed

	if Input.is_key_pressed(KEY_D) and alive:
		velocity.x += moveSpeed
	
	if velocity.x != 0:
		isMoving = true
	
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor() and canJump and alive:
		velocity.y = -jumpForce
		canJump = false # Set ability to fire to false, so can't fire
		await get_tree().create_timer(jumpRate).timeout # This waits to execute the next line. Adjust variable to be able to fire faster.
		canJump = true # Set fire back to true so can fire again
	
	move_and_slide() # Need this to move when two objects are colliding (The floor and player). See documentation
	
	if global_position.y > 150: # if you fall off the side of the level, it reloads the scene
		game_over()
	
func game_over(): # Just reloads the screen on death
	get_tree().reload_current_scene()
	
func sprite_animations():
	
	var currentTargetPos = get_node("../Crosshair").global_position # Grab the current position of the Crosshair
	var distancePlayerToTarget = abs(global_position - currentTargetPos) # This shows the distance of the target from the player
	var animFlipChecker = currentTargetPos - global_position # This math tells me if it's to the left or right of the player
	
	if animFlipChecker.x < 0 and distancePlayerToTarget.x > 15 and alive: # Normal orientation
		$AnimatedSprite2D.flip_h = 0
		if aimingMid and alive:
			$shotSpawn.position = Vector2(-14.65,-16.805)
		if aimingHigh and alive:
			$shotSpawn.position = Vector2(-14.65,-20.805)
		
	if animFlipChecker.x >= 0 and distancePlayerToTarget.x > 15 and alive: # Flip the sprite if we're aiming the other way
		$AnimatedSprite2D.flip_h = 1
		if aimingMid and alive:
			$shotSpawn.position = Vector2(14.65,-16.805)
		if aimingHigh and alive:
			$shotSpawn.position = Vector2(14.65,-20.805)
			

	if velocity.x < 0 and alive: # This flips the sprites if moving left
		$AnimatedSprite2D.flip_h = 1
	if velocity.x > 0 and alive: # Set it back
		$AnimatedSprite2D.flip_h = 0

# Sounds attatched to the player
	if alive and isMoving and !isJumping and $FootSteps.get_playback_position() == 0:
		$FootSteps.play()
	if alive and !isMoving:
		$FootSteps.stop()
	if alive and isJumping:
		$FootSteps.stop()
		

	if alive and !isMoving and !isJumping and distancePlayerToTarget.x > 15 and distancePlayerToTarget.x < 65 and distancePlayerToTarget.y <= 85: #aiming mid and low
		aimingMid = true
		aimingHigh = false
		state_machine.travel("Aiming-Mid-Slight")

	if alive and !isMoving and !isJumping and distancePlayerToTarget.x >= 65 and distancePlayerToTarget.x < 125 and distancePlayerToTarget.y <= 85: #aiming mid and low
		aimingMid = true
		aimingHigh = false
		state_machine.travel("Aiming-Mid-Medium")

	if alive and !isMoving and !isJumping and distancePlayerToTarget.x >= 125 and distancePlayerToTarget.y <= 85: #aiming mid and low
		aimingMid = true
		aimingHigh = false
		state_machine.travel("Aiming-Mid-Full")

	if alive and !isMoving and !isJumping and distancePlayerToTarget.x >= 15 and distancePlayerToTarget.x < 65 and distancePlayerToTarget.y >= 85: #aiming mid and low
		aimingMid = false
		aimingHigh = true
		state_machine.travel("Aiming-Up-Slight")

	if alive and !isMoving and !isJumping and distancePlayerToTarget.x >= 65 and distancePlayerToTarget.x < 125 and distancePlayerToTarget.y >= 85: #aiming mid and low
		aimingMid = false
		aimingHigh = true
		state_machine.travel("Aiming-Up-Medium")
		
	if alive and !isMoving and !isJumping and distancePlayerToTarget.x >= 125 and distancePlayerToTarget.y >= 85: #aiming mid and low
		aimingMid = false
		aimingHigh = true
		state_machine.travel("Aiming-Up-Full")

	if alive and !isMoving and !isJumping and abs(global_position.x - currentTargetPos.x) < 15:
		state_machine.travel("Idle")
		aimingHigh = false
		aimingMid = false
		$shotSpawn.position = Vector2(-0.87,-16.295)
#
	if alive and isMoving and isJumping:
		state_machine.travel("Jump")
#
	if alive and !isMoving and isJumping:
		state_machine.travel("Jump_n")
#
	if alive and isMoving and !isJumping:
		state_machine.travel("Run")
#		if $FootSteps.get_playback_position() == 0:


# This is the death section, it's kind of a mess, but it does work atm! Should re-do and make cleaner
	if !alive and !wentUp:
		state_machine.travel("Dead-Going-Up")
		$DeathSound.play()
		velocity.y = -190
		await get_tree().create_timer(.2).timeout
		wentUp = true
	
	if !alive and wentUp and !is_on_floor():
		state_machine.travel("Dead-Going-Down")
		
	if !alive and is_on_floor() and wentUp:
		state_machine.travel("Dead-Grounded")
		
		await get_tree().create_timer(.3).timeout
		visible = randi_range(0,1) # This flickers the sprite back and forth to make a fade out illusion
		await get_tree().create_timer(.3).timeout
		postDeathInvuln = true
		alive = true
		wentUp = false
		
		

func aiming_close_mid(): # Leave this in for now, I have it hooked up to an aiming animation
	pass
		#animation_player.pause()
		#call_deferred()
