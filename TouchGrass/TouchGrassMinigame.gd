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
@export var hand_size = Vector2(1.54, 0.29)
@export var worm_max_x : float = 2
@export var worm_size = Vector2(1.0, 0.51)

var game_state = GAME_STATE.playing
var game_ended_timestamp = 0.0
const game_ended_wait_duration = 3.0

func _ready() -> void:
	hand.position.x = (randf() * 2 - 1) * hand_max_x
	worm.position = generate_worm_position()

func _process(delta: float) -> void:
	if update_game_over():
		return
	
	move_hand(delta)
	var is_failure = check_worm_contact()
	if not is_failure:
		check_success()
	
	#TODO: Reposition worms after a while?

func update_game_over() -> bool:
	if game_state == GAME_STATE.playing:
		return false
	
	# Exit minigame a few seconds after success/failure:
	var exit_timestamp = game_ended_timestamp + game_ended_wait_duration
	var current_timestamp = Time.get_unix_time_from_system()
	if current_timestamp >= exit_timestamp:
		# Destroy the minigame node:
		var minigame_root = find_sub_scene_root()
		if minigame_root != null:
			minigame_root.queue_free()
	
	return true

func find_sub_scene_root() -> Node:
	var node = self
	while node != null and node.name != "TouchGrassScene":
		node = node.get_parent()
	
	if node == null:
		return null
	
	while node is not SubViewport:
		node = node.get_parent()
	return node

func move_hand(delta: float) -> void:
	var input = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	var move_speed = input * hand_move_speed
	var move_offset = move_speed * delta
	
	var pos_x = clamp(hand.position.x + move_offset.x, -hand_max_x, hand_max_x)
	var pos_y = min(hand.position.y + move_offset.y, start_height)
	hand.position.x = pos_x
	hand.position.y = pos_y

func check_worm_contact() -> bool:
	var hx0 = hand.position.x - hand_size.x * 0.5
	var hy0 = hand.position.y - hand_size.y * 0.5
	var hx1 = hx0 + hand_size.x
	var hy1 = hy0 + hand_size.y
	
	var wx0 = worm.position.x - worm_size.x * 0.5
	var wy0 = worm.position.y - worm_size.y * 0.5
	var wx1 = wx0 + worm_size.x
	var wy1 = wy0 + worm_size.y
	
	var no_overlap = hx1 < wx0 or hx0 > wx1 or hy1 < wy0 or hy0 > wy1
	
	if no_overlap:
		return false
	else:
		set_game_state(GAME_STATE.failure)
		return true

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
	
	#var room_scene = get_tree().current_scene
	#var room_scene_script = room_scene.get_script()
	#var game_manager = room_scene_script as GameManager
	
	if game_state != GAME_STATE.playing:
		game_ended_timestamp = Time.get_unix_time_from_system()
	
	if game_state == GAME_STATE.success:
		label_worms.text = "You touched grass!"
		#game_manager.decrease_stress(0.2)
	elif game_state == GAME_STATE.failure:
		label_worms.text = "Gross! You touched a worm!"
		#game_manager.increase_stress(0.2)
