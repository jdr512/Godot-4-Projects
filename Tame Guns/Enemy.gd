extends Area2D

@export var moveSpeed : float = .4
@export var moveDir : Vector2

@onready var startPos = global_position
@onready var playerPos = get_node("../Player").global_position

var targetPos : Vector2
var currentPlayerPos : Vector2
var secondMovement : bool
var canFire = true
var firstBulletDelay : int = 0

var boom = preload ("res://explosion.tscn")					# Enemy Explosion animation and sound
var enemyBullet = preload ("res://enemybullet.tscn") 		# Preload the bullet scene so it can spawn
var iconHeavyMG = preload ("res://icon_machine_gun.tscn") 	# The icon for Heavy Machine Gun


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	currentPlayerPos = get_node("../Player").global_position
	
	firstBulletDelay += 1 # delays first shot
	
	if canFire and firstBulletDelay >= 150:
		
		var eb = enemyBullet.instantiate() # This creates a copy of the scene definied in var bullet above and thus the script for the bullet
		add_sibling(eb)
		eb.transform = $shotSpawn.global_transform # Force the bullet to spawn at shotSpawn marker
		canFire = false # Set ability to fire to false, so can't fire
		await get_tree().create_timer(2).timeout # This waits to execute the next line. Adjust variable to be able to fire faster.
		canFire = true # Set fire back to true so can fire again
	
	
	if global_position.distance_to(playerPos) > 1 and !secondMovement:
		global_position = global_position.move_toward(playerPos, moveSpeed)
		
	if global_position.distance_to(startPos) > 100:
		secondMovement = true
	
	if secondMovement:
		#global_position = global_position.move_toward(currentPlayerPos, moveSpeed) # move to player's new location
		global_position = global_position.move_toward(startPos, moveSpeed)
#		print("Second Movement Activated")
	
	if global_position.distance_to(startPos) < 1:
		secondMovement = false
	
#	if global_position == targetPos:
#		if global_position == startPos:
#			targetPos = startPos + moveDir
#		else:
#			targetPos = startPos


#func _on_body_entered(body):
#	if body.is_in_group("Player"):
#		body.game_over()

func _on_area_entered(area):
	if area.is_in_group("playerBullet"):
		
		var randomNum = randi_range(1,100)
		var bm = boom.instantiate() # Creates an instance of an explosion at the enemy
		add_sibling(bm)
		get_node("../").add_score(1)
		bm.play("Boom")
		bm.global_position = global_position
		
		if randomNum >= 50 and get_node("../Player").hasMachineGun == false and get_node("../EnemySpawner").heavyMGIconExists == false:
			var icon = iconHeavyMG.instantiate()
			add_sibling(icon)
			icon.global_position = bm.global_position
			get_node("../EnemySpawner").heavyMGIconExists = true
			
		queue_free()
		
		

