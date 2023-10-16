extends Area2D

var mousePosition : Vector2
var mouseGlobal : Vector2

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) # hide mouse cursor
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN) # Confine mouse to window and hide
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	position = Vector2(-500,-500)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

#func _unhandled_input(event):
	
#	var direction : Vector2
	#var mouseVelocity = event.velocity
#
#	if event is InputEventMouseMotion: # triggers if mouse has motion 
#		pass
#		#print(event)
#
##		if event.velocity == Vector2(0,0):
##			await get_tree().create_timer(5).timeout
##			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _physics_process(_delta):
	#mousePosition = get_global_mouse_position() - get_node("../").cameraPosition 	# Store global mouse pos inside of mousePosition variable
	position = get_global_mouse_position()

func _process(_delta):
	#position = InputEventMouseMotion.get_relative()
	pass
	
	
