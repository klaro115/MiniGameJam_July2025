extends StaticBody3D

@export var type: String;

func _input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int):
	if (event is InputEventMouseButton) &&\
	(event as InputEventMouseButton).button_index == 1 &&\
	(event as InputEventMouseButton).pressed == true:
		print("tel")
