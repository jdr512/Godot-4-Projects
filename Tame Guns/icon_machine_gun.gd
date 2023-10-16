extends Area2D


func _ready():
	turn_off_collision_momentarily()
	await get_tree().create_timer(3).timeout
	get_node("../EnemySpawner").heavyMGIconExists = false
	queue_free()
	
func turn_off_collision_momentarily():
	$CollisionShape2D.disabled = 1
	visible = false
	await get_tree().create_timer(.5).timeout
	$CollisionShape2D.disabled = 0
	visible = true
	

func _on_area_entered(area):
	if area.is_in_group("playerBullet") and $CollisionShape2D.disabled == false:
		get_node("../Player").machineGunAmmo += 40 # Give player 40 bullets for machine gun
		get_node("../Player").hasMachineGun = true # Enable machine gun fire script in player.gd script
		get_node("../Player/Weapon_Pick_Up_Sounds/HeavyMachineGun").play() # Play the pickup sound
		get_node("../EnemySpawner").heavyMGIconExists = false
		queue_free()
