extends Ability

export (int) var min_dist = 1
const bfs_path = "res://Scripts/Pathing/BFS.gd"
const bfs_class = preload(bfs_path)

var god
var bfs

func _use_ability(player, target):
	bfs = bfs_class.new()
	bfs.init(god)
	var path = bfs.find_path(player.grid_position, target)
	
	if(path != null):
		SoundEngine.play_footsteps_sfx()
		yield(player.do_move(path.slice(1,len(path) - 1)), "completed")
		player.dist_moved += path.size() - 1
		SoundEngine.stop_sfxPlayer()
	finish_doing()
	pass

func _ready():
#	randomize()
	god = get_node("/root/World")


func _ability_conditions(player):
	return player.get_moveable_distance() > 0

func get_details(lifecycle):
	var super_details = .get_details(lifecycle) + "\n"
	
	super_details += "Tiles per turn: %s \n" % lifecycle.player.tiles_per_turn
	super_details += "Moveable tiles: %s \n" % lifecycle.player.get_moveable_distance()
	
	return super_details
