extends Area2D

@onready var speed = 4 												 # bullet speed multiplier
@onready var playerMoving = get_node("../Player").isMoving			 # Is Player moving yes/no
@onready var playerLocation = get_node("../Player").global_position  # Location of player on bullet creation
@onready var playerVelocity = get_node("../Player").velocity
@onready var target = get_node("../Crosshair").global_position 		 # Snapshot of Target's Location upon firing
#@onreadyd var cameraPosition = get_node("../").cameraPosition         # Camera's target position, in global coordinates on bullet creation


func _ready():
	pass
	#print(target) # print location of Crosshair node at creation of bullet instance
	
func _process(delta):
	
#	var velocity = Vector2.ZERO
#	var angle = get_angle_to(target)
#	velocity.x = cos(angle)
#	velocity.y = sin(angle)
#	global_position += velocity * speed * delta
	
	if global_position.distance_to(target) > 5:
		global_position += global_position.direction_to(target) * speed
	if global_position.distance_to(target) <= 5:
		global_position += target * 0
		$Sprite.scale += Vector2(-.1,-.1) * 10 * delta # More aggressively shrink the bullet when it reaches the target
		
	
	#position = position.move_toward(target, speed)
	#position += (target - playerLocation) * speed * delta   # Old Version of bullet behavior
	#print(position.x)
	$Sprite.scale += Vector2(-.1,-.1) * speed * delta # Make bullets get smaller as they travel, but just the sprites. Collision stays big
	if $Sprite.scale.x <= 0.5:
		$CollisionShape2D.disabled = 1
	if $Sprite.scale.x <= 0: # Destroy bullets when scale == 0
		queue_free()
	
	
	
func _physics_process(_delta):
	if global_position.y == target.y:
		queue_free()
		
	await get_tree().create_timer(100).timeout # destroy bullet if a lot of time passes, just in case
	queue_free()
		
#		if target != get_node("../Crosshair").global_position and position.x > 0 and position <= ( target - Vector2(3,0) ):
#			position += (get_node("../Crosshair").global_position - playerLocation) * speed * delta
#			#position = position.move_toward(get_node("../Crosshair").global_position, speed+20)
#
#		if target != get_node("../Crosshair").global_position and position.x < 0 and position >= ( target - Vector2(-3,0) ):
#			position += (get_node("../Crosshair").global_position - playerLocation) * speed * delta
#			#position = position.move_toward(get_node("../Crosshair").global_position, speed+20)
	
	#if position.distance_to(target) < 20 and 
#	if position.distance_to(currentTargetPos) <= 50 and target.distance_to(currentTargetPos) <= 200 and position != target and position != currentTargetPos:
#		#position = global_position.move_toward(currentTargetPos, speed+5)
#		position = position.lerp(currentTargetPos, .5)
	
		
		
	
#	if (playerLocation.y - target.y) >= 50:
#		position += (target - playerLocation) * speed  * delta
#
#
#	if (playerLocation.y - target.y) < 50:
#		position += (target - playerLocation) * closeSpeed  * delta
	

func _on_area_entered(area): # Destroy bullet on impact with enemy
	if area.is_in_group("Enemy"):
		queue_free()
	if area.is_in_group("enemyBullet"):
		queue_free()
