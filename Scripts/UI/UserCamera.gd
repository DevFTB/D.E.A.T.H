extends Camera2D

export (float) var default_zoom = 2;
export (float) var focus_zoom = 2.5;

export (float) var move_speed_scaling

var should_move = false

func _ready():
	zoom = Vector2(default_zoom, default_zoom)



func focusOn(target: Vector2):
	$Tween.interpolate_property(self, "global_position", self.global_position, target, 0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "zoom", self.zoom, Vector2(focus_zoom,focus_zoom), 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
func unfocus():
	$Tween.interpolate_property(self, "zoom", self.zoom, Vector2(default_zoom,default_zoom), 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_action("move_camera"):
			should_move = event.pressed
			if(event.pressed):
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	if event is InputEventMouseMotion and should_move:
		position += event.relative * move_speed_scaling

