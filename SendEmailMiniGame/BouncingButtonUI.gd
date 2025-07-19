extends Control

@onready var button = $"Button"
var can_move = false 

var min_speed = 800 
var max_speed = 800
var current_speed = 0

var direction = Vector2(1, 1)

func _ready():
	await get_tree().create_timer(1.0).timeout
	can_move = true
	randomize()
	current_speed = randf_range(min_speed, max_speed)
	_set_random_direction()
	
	var screen_size = get_viewport_rect().size
	button.position = (screen_size - button.size) / 2
	
	# Optional: Add slight random offset (keep if you want some variation)
	var random_offset = Vector2(
		randf_range(-50, 50),
		randf_range(-50, 50)
	)
	button.position += random_offset
	
	button.pressed.connect(_on_button_pressed)

	var initial_center = (get_viewport_rect().size / 2) - (button.size / 2)
	var random_offset_range = 50


func _set_random_direction():
	var random_x = randf_range(-1.0, 1.0)
	var random_y = randf_range(-1.0, 1.0)
	
	var min_abs_component = 0.3
	if abs(random_x) < min_abs_component:
		random_x = sign(random_x) * min_abs_component if random_x != 0 else min_abs_component
	if abs(random_y) < min_abs_component:
		random_y = sign(random_y) * min_abs_component if random_y != 0 else min_abs_component
	
	direction = Vector2(random_x, random_y).normalized()

func _process(delta):
	button.position += direction * current_speed * delta
	
	if not can_move:
		return

	var screen_size = get_viewport_rect().size
	var button_rect = Rect2(button.global_position, button.size)
	var bounced = false

	# left wall
	if button_rect.position.x < 0:
		button.global_position.x = 0
		_set_random_direction()
		direction.x = abs(direction.x) 
		bounced = true
		
	# right wall
	elif button_rect.position.x + button_rect.size.x > screen_size.x:
		button.global_position.x = screen_size.x - button_rect.size.x
		_set_random_direction()
		direction.x = -abs(direction.x) 
		bounced = true

	# top wall
	if button_rect.position.y < 0:
		button.global_position.y = 0
		_set_random_direction()
		direction.y = abs(direction.y)
		bounced = true
		
	# bottom wall
	elif button_rect.position.y + button_rect.size.y > screen_size.y:
		button.global_position.y = screen_size.y - button_rect.size.y
		_set_random_direction()
		direction.y = -abs(direction.y)
		bounced = true

	if bounced:
		current_speed = randf_range(min_speed, max_speed)
		direction = direction.normalized()

func _on_button_pressed():
	print("Button Clicked!")

	
