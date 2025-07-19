extends Node3D

class_name GameManager

var _stress_level = 0.0;

func increase_stress(amount : float):
	_stress_level += amount
	update_user_interface()

func decrease_stress(amount : float):
	_stress_level -= amount
	update_user_interface()

func update_user_interface():
	#TODO
	return
