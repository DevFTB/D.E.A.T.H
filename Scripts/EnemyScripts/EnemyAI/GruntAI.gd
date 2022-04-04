extends BFSAI

func generate_turn(abilities):
	var move_ability = abilities[0]
	
	var other_ability = abilities[1]
	if(abilities.size() > 2):
		var other_abilities = abilities.slice(1,len(abilities) - 1)
		other_ability  = other_abilities[randi() % len(other_abilities)]
		
	return [move_ability, other_ability]

func evaulate_tile():
	# + points if a target within skill range/closer to target
	# + points for high acc to target
	# - points for all enemies with high acc towards it
	pass
