extends Button

var button_pressed

func change_scene() -> void:
		get_tree().change_scene("res://Scenes/World.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _button_pressed():
	change_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
