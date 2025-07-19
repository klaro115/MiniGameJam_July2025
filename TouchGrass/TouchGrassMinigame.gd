extends Node3D

@export var hand : Node3D
@export var pot : Node3D
@export var startHeight : float = 2.0
@export var endHeight : float = -0.8
@export var hand_max_x : float = 2
@export var hand_move_speed : float = 1.5

func _process(delta: float) -> void:
	move_hand(delta)
	check_success()

func move_hand(delta: float):
	var input = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	var move_speed = input * hand_move_speed
	var move_offset = move_speed * delta
	
	var pos_x = clamp(hand.position.x + move_offset.x, -hand_max_x, hand_max_x)
	var pos_y = min(hand.position.y + move_offset.y, startHeight)
	hand.position.x = pos_x
	hand.position.y = pos_y

func check_success():
	if hand.position.y > endHeight:
		return
	
	#TODO: Victory, do something.
	
	# Destroy the minigame node:
	queue_free()
