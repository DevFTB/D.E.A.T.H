extends Node2D
class_name Enemy

export (int) var max_health = 5
export (int) var tiles_per_move = 5
export (bool) var can_cover = true

var health
var abilities = []
var ai
var grid_position
var god

func _ready():
	health = max_health
	abilities = $Abilities.get_children()
	ai = $AI
	god = get_tree().root.get_child(0)
	
	# temp
	yield(get_tree(), "idle_frame")
	grid_position = god.world_to_grid(position)
	

func new_turn():
	if(ai.has_method("get_move")):
		var move = ai.get_move()
		grid_position = move[-1]
		print(grid_position)
		position = god.grid_to_world(grid_position)
		
func die():
	pass

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		die()

func _on_World_new_turn():
	new_turn()
