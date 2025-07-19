extends Node3D

enum GAME_STATE { playing, success, failure }

@export var hand : Node3D
@export var pot : Node3D
@export var worm : Node3D

@export var label_worms : Label3D

@export var start_height : float = 2.0
@export var end_height : float = -0.8
@export var hand_max_x : float = 2
@export var hand_move_speed : float = 1.5
@export var hand_size = Vector2(0.4, 0.2)
@export var worm_max_x : float = 2
@export var worm_size = Vector2(0.4, 0.2)

var game_state = GAME_STATE.playing 

func _ready() -> void:
	hand.position.x = (randf() * 2 - 1) * hand_max_x
	worm.position = generate_worm_position()

func _process(delta: float) -> void:
	move_hand(delta)
	if not check_worm_contact():
		check_success()
	
	#TODO: Reposition worms after a while?
	
	# Destroy the minigame node:
	#if game_state != GAME_STATE.playing:
		#TODO: Delay this:
	#	queue_free()

func move_hand(delta: float) -> void:
	var input = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	var move_speed = input * hand_move_speed
	var move_offset = move_speed * delta
	
	var pos_x = clamp(hand.position.x + move_offset.x, -hand_max_x, hand_max_x)
	var pos_y = min(hand.position.y + move_offset.y, start_height)
	hand.position.x = pos_x
	hand.position.y = pos_y
	
func check_worm_contact() -> bool:
	var hand_pos = Vector2(hand.position.x, hand.position.y)
	var worm_pos = Vector2(worm.position.x, worm.position.y)
	var hand_rect = Rect2(hand_pos - hand_size * 0.5, hand_size)
	var worm_rect = Rect2(worm_pos - worm_size * 0.5, worm_size)
	
	if hand_rect.intersects(worm_rect):
		set_game_state(GAME_STATE.failure)
		return true
	else:
		set_game_state(GAME_STATE.playing)
		return false

func check_success() -> bool:
	if hand.position.y > end_height:
		return false

	set_game_state(GAME_STATE.success)	
	return true

func generate_worm_position() -> Vector3:
	var pos_x = worm_max_x * (randf() * 2 - 1)
	return Vector3(pos_x, 0, 0.0)

func set_game_state(new_state: GAME_STATE) -> void:
	if game_state == new_state:
		return
	
	game_state = new_state
	
	if game_state == GAME_STATE.success:
		label_worms.text = "You touched grass!"
	elif game_state == GAME_STATE.failure:
		label_worms.text = "Gross! You touched a worm!"
