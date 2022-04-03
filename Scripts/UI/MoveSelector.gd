extends Selector


const bfs_path = "res://Scripts/Pathing/BFS.gd"
const bfs_class = preload(bfs_path)

var bfs
var reachable

func _ready():
	bfs = bfs_class.new()
	bfs.init(self.god)
	reachable = bfs.get_reachable(lifecycle.player.grid_position, lifecycle.player.tilesPerMove)
	get_node("/root/World/Overlay").set_overlay(reachable)
	
func select_tile():
	var mouse_pos = get_global_mouse_position()
	var grid_pos = floor_tile_map.world_to_map(mouse_pos)
	
	if reachable.find(grid_pos) != -1:
		selection = floor_tile_map.world_to_map(mouse_pos)
		emit_signal("on_select_tile", selection)
	
	pass

func _exit_tree():
	get_node("/root/World/Overlay").clear_overlay();
