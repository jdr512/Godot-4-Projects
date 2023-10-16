extends Node2D

var enemy = preload ("res://enemy.tscn") # Preload the enemy scene so it can spawn

@onready var canSpawn : bool = true
@onready var enemyPos : Vector2 = $Spawn_1.global_position
@onready var enemySpawnDelay : int = 0
var heavyMGIconExists = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#enemySpawnDelay += 1 # delays spawn
	#print_orphan_nodes()
	pass

	if canSpawn:# and enemySpawnDelay >= 50:

		var d = enemy.instantiate()
		#d.set_owner(get_node("../Player"))
		owner.add_child(d)
		var randomNum = randi_range(1,6)
		
		if randomNum == 1:
			d.transform = $Spawn_1.global_transform # Force the enemy to spawn at marker
			_can_spawn_setup()
		if randomNum == 2:
			d.transform = $Spawn_2.global_transform # Force the enemy to spawn at marker
			_can_spawn_setup()
		if randomNum == 3:
			d.transform = $Spawn_3.global_transform # Force the enemy to spawn at marker
			_can_spawn_setup()
		if randomNum == 4:
			d.transform = $Spawn_4.global_transform # Force the enemy to spawn at marker
			_can_spawn_setup()
		if randomNum == 5:
			d.transform = $Spawn_5.global_transform # Force the enemy to spawn at marker
			_can_spawn_setup()
		if randomNum == 6:
			d.transform = $Spawn_6.global_transform # Force the enemy to spawn at marker
			_can_spawn_setup()
		
func _can_spawn_setup():
		canSpawn = false
		await get_tree().create_timer(2).timeout # This waits to execute the next line.
		canSpawn = true
