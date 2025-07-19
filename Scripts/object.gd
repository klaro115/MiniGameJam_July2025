extends StaticBody3D

@export var type: String;

func _input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int):
	if (event is InputEventMouseButton) &&\
	(event as InputEventMouseButton).button_index == 1 &&\
	(event as InputEventMouseButton).pressed == true:
		print(type)
		#(get_node("../SubViewportContainer/MinigameViewport") as SubViewport).get_texture().viewport_path = "res://TouchGrass/TouchGrassScene.tscn";
		(get_node("../../SubViewportContainer") as SubViewportContainer).show()
		var scene: Resource = null;
		if type == "Grass":
			scene = load("res://TouchGrass/TouchGrassScene.tscn")
		elif type == "mail":
			scene = load("res://SendEmailMiniGame/BoucingButtonUI.tscn")
		get_node("../../SubViewportContainer/MinigameViewport").get_child(0).add_child(scene.instantiate());
