extends CharacterBody2D

var moveSpeed : float = 75
var jumpForce : float = 150
var gravity : float = 700

var bullet = preload ("res://Bullet.tscn") # Preload the bullet scene so it can spawn
var canFire = true
@onready var playerLocation = get_node("../Player").global_position
@export var fireRate = .3

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and canFire: # If the Cooldown for firing is up, fire if left mouse button has been clicked
		var b = bullet.instantiate() # This creates a copy of the scene definied in var bullet above and thus the script for the bullet
		owner.add_child(b) # Make a child of root ("Owner")
		b.transform = $shotSpawn.global_transform # Force the bullet to spawn at shotSpawn marker
		canFire = false # Set ability to fire to false, so can't fire
		await get_tree().create_timer(fireRate).timeout # This waits to execute the next line. Adjust variable to be able to fire faster.
		canFire = true # Set fire back to true so can fire again
		print("**Delta=" , _delta)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	velocity.x = 0
	
	if Input.is_key_pressed(KEY_A):
		velocity.x -= moveSpeed
		print("playrlocation= ", playerLocation)
	if Input.is_key_pressed(KEY_D):
		velocity.x += moveSpeed
		print("playrlocation= ", playerLocation)
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = -jumpForce
	move_and_slide()

	
	
	if global_position.y > 150:
		game_over()
	
func game_over ():
	get_tree().reload_current_scene()
	
