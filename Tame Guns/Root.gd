extends Node2D

var cameraPosition :  Vector2
var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
			
			
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_Q:
			get_node("Player").game_over()

func _physics_process(_delta):
	if get_node("Player").hasMachineGun == true:
		$UI/AmmoIcon/Amount.text = str(get_node("Player").machineGunAmmo)
		$UI/AmmoIcon/Amount.scale = Vector2(1,1)
		$UI/AmmoIcon/Amount.set_position(Vector2(6,-8), true)
		
	if get_node("Player").hasMachineGun == false:
		$UI/AmmoIcon/Amount.scale = Vector2(1.5,1.5)
		$UI/AmmoIcon/Amount.text = str("∞")
		$UI/AmmoIcon/Amount.set_position(Vector2(6,-13), true)
	

func add_score (amount):
	score += amount
	get_node("UI/scoreText").text = str("Score: ", score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	cameraPosition = $Player/Camera.get_target_position()
