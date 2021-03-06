extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#export (Texture) var health_segment_filled
#export (Texture) var health_segment_unfilled
#export (int) var segment_width = 4
#export (int) var segment_border = 1
export (int) var segment_size = 5

onready var healthbar = $HealthBar
onready var healthbarempty = $HealthBarEmpty

var max_health = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if(get_parent() and get_parent().get("max_health")):
		max_health = get_parent().max_health
	
	healthbarempty.rect_size.x = max_health * segment_size
	position.x = -(healthbarempty.rect_size.x / 2)
	update()
	
func update():
	if get_parent() and (get_parent().get("health") != null):
		if(get_parent().health <= 0):
			healthbar.visible = false
			healthbarempty.visible = false
		else:
			healthbar.visible = true
			healthbarempty.visible = true
			healthbar.rect_size.x = get_parent().health * segment_size

func _on_Unit_update_attr():
	update()
	pass


func _on_Civilian_update_attr():
	pass # Replace with function body.
