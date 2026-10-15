extends Node2D

@onready var player = get_node("Play")
@onready var asteroid = get_node("Asteroid")
@onready var asteroid2 = get_node("Asteroid2")
@onready var enemy = $Enemy
@onready var enemies: Node2D = $Enemies
@onready var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

var count: int = 10  #  10 врагов

func _ready() -> void:
	# Подключаем оба астероида
	asteroid.colided.connect(player.reset_lifetime)
	asteroid2.colided.connect(player.reset_lifetime)
	
	for i in count:
		var enemy_instance = enemy_scene.instantiate()
		enemy_instance.scale = Vector2(0.5, 0.5)
		enemies.add_child(enemy_instance)

func _process(delta: float) -> void:
	# враг кружит вокруг игрока
	enemy.orbit(player.position, 150.0, delta)
	
	for child in enemies.get_children():
		child.alignment(enemies)
	
	
	var player_pos = player.position
	for child in enemies.get_children():
		if player_pos.distance_to(child.position) < 45.0:
			player.reset_lifetime()
	
	# Проверка столкновения с кружащимся врагом
	if player_pos.distance_to(enemy.position) < 45.0:
		player.reset_lifetime()
