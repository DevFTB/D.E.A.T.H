extends Node2D
class_name Enemy

export (int) var max_health
export (int) var tiles_per_move

export (int) var can_attack
export (int) var attack_range
export (int) var attack_dmg

var health
var abilities = []
var ai
var grid_position = Vector2(0, 0)

func _ready():
	health = max_health
	abilities = $Abilities.get_children()
	ai = $AI
	
	# todo: remove, shouldnt be called from here for tesing 
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		new_turn()
	

func new_turn():
	var move = [grid_position]
	if(ai.has_method("get_move")):
		move = ai.get_move(self)
	print(move)
