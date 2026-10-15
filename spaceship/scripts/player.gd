extends Node2D


var speed: float = 0
var max_speed: float = 500
var velocity: Vector2 = Vector2(0,0) # текущая скорость в определенном напрвлении

# счётчик времени жизни корабля
var lifetime: float = 0.0

@onready var speedLabel: Label = get_node("speedometer")

@onready var sprite: Sprite2D = get_node("shift_sprite/shield")
var shield_restoration: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		speed += 500 * delta
		if speed > max_speed:
			speed = max_speed
	if Input.is_action_pressed("ui_down"):
		speed -= 500 * delta
		if speed < 0:
			speed = 0
	if Input.is_action_pressed("ui_left"):
		rotation -= 5 * delta
	if Input.is_action_pressed("ui_right"):
		rotation += 5 * delta
		
	# система полярных координат
	var x = 0.1 * cos(rotation + PI / 2)
	var y = 0.1 * sin(rotation + PI / 2) 
	
	velocity = speed * delta * Vector2(x, y).normalized()
	
	# время жизни
	speedLabel.text = ("Life: %.1f" % lifetime)
	
	speedLabel.rotation = -rotation
	speedLabel.global_position = global_position + Vector2(0, -70)
	
	position += velocity
	
	# счётчик времени жизни
	lifetime += delta
	
	if shield_restoration > 0:
		shield_restoration -= delta
	if shield_restoration <= 0:
		sprite.visible = true
			
			
func damaged():
	sprite.visible = false
	shield_restoration = 1.0
	# сбрасываем счётчик при повреждении
	reset_lifetime()


#  метод для сброса счётчика в ноль
func reset_lifetime():
	lifetime = 0.0
