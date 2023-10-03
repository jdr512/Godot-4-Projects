extends Area2D

@onready var speed = 2# bullet speed multiplier
@onready var target = get_node("../Crosshair").global_position # store location of Crosshair node at creation of bullet instance
@onready var playerLocation = get_node("../Player").global_position
@onready var playerVel = get_node("../Player").velocity

func _ready():
	print("target",target) # print location of Crosshair node at creation of bullet instance
	target.x += 20 # x adjustment for sprite image x
	target.y -= 8  # y adjustment for sprite image
	print("global posish=",global_position)
	print("playerVelocity:",playerVel)
#	target = target.normalized()

func _physics_process(delta):
#	global_position += ((target * speed  * delta ) - playerLocation) 
	var targetLocationReflect = target.reflect(playerLocation) 

	global_position += ((target-playerLocation) * speed  * delta ) 
	
#	global_position = (global_position - global_position1Reflect)
#	global_position += (targetLocation * speed  * delta)
	scale += Vector2(-.1,-.1) * 8 * delta # Make bullets get smaller as they travel
	
	if global_position.y == target.y:
		queue_free()
	if scale.x <= 0:
		queue_free()
	
		
	await get_tree().create_timer(3).timeout
	queue_free()
	
#func _process(delta):
#	pass
