extends Area2D

var mousePosition : Vector2
var mouseGlobal : Vector2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) # hide mouse cursor

func _process(_delta):
	mousePosition = get_global_mouse_position() # Store global mouse pos inside of mousePosition variable
	position = mousePosition                    # set position of node to mousePosition Vector2 variable
#	print("MousePosit:", position)
	
	

