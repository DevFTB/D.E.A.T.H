extends Node

#export (Array, NodePath) var player_unit_node_paths
#onready var player_units = load_nodes(player_unit_node_paths)
export (NodePath) var obstacle_map_path
export (NodePath) var floor_map_path
export (int) var mark_acc_increase = 20

export (Array, PackedScene) var players

onready var obstacle_tile_map = get_node(obstacle_map_path)

onready var floor_tile_map = get_node(floor_map_path)
var cover

var civlians_evacuated = 0
var players_killed = 0

# all other obstacles are 0 over
var cover_map = {
					"Building wall 1": 1,
					"Building wall 2": 1,
					"CORNER TOWER": 1,
					"PYLON": 1,
					"half pylon.png 4": 0.5
}

var unwalkable_tile_names = ["waterr.tres 4"]

func _ready():
	
	SoundEngine.play_combat_music()
	cover = Cover.new()
	cover.init(obstacle_tile_map, cover_map)
	set_process_input(true)
	
	spawn_players()
	
	$Spawner/CivilianSpawner.spawn_civilians(self)
	$Spawner/EnemySpawner.force_spawn(0)
	init_entities()	
	init_world()

	$TurnManager.new_turn()


func spawn_players():
	for i in range(0, players.size()):
		var player = players[i].instance()
		player.connect("death", self, "increment_dead_count")
		$Cover.add_child(player)
		
		var snapped_pos = world_to_grid($Spawner/PlayerSpawnPoints.get_child(i).global_position)
		player.position = grid_to_world(snapped_pos)

func increment_dead_count():
	players_killed += 1
	check_game_over()

func check_game_over():
	if players_killed == players.size() or get_civilian_nodes().size() == 0:
		game_over()

func game_over():
	$UI/HUD.visible = false
	
	$AnimationPlayer.play("fade out")
	yield($AnimationPlayer, "animation_finished")

	$"UI/Game Over".visible = true
	

func init_entities():
	for en in get_enemy_nodes():	
		en.grid_position = world_to_grid(en.position)
	
	for player in get_player_nodes():
		player.grid_position = world_to_grid(player.position)
		
	for civilian in get_tree().get_nodes_in_group("civilian"):
		civilian.grid_position = world_to_grid(civilian.position)

func init_entity(entity):
	entity.grid_position = world_to_grid(entity.position)
	
func init_world():
	for obj in get_tree().get_nodes_in_group("world_object"):
		obj.grid_position = world_to_grid(obj.position)
		obj.init()

#func load_nodes(nodePaths: Array) -> Array:
#	var nodes := []
#	for nodePath in nodePaths:
#		var node := get_node(nodePath)
#		if node != null:
#			nodes.append(node)
#	return nodes

func get_evacuation_areas():
	return get_tree().get_nodes_in_group("evacuation_area")

func get_active_evacuation_areas():
	var evacuation_areas = get_evacuation_areas()

	var list = []
	for ea in evacuation_areas:
		if(ea.is_active):
			list.append(ea)

	return list
	
func evacuate_civilian(civilian):
	civlians_evacuated += 1
	
	# on civilian evacuated effects
	
	civilian.queue_free()

func get_civilian_nodes(alive=true):
	var civilian_nodes = get_tree().get_nodes_in_group("civilian")
	if alive:
		var list = []
		for p in civilian_nodes:
			if !p.is_dead:
				list.append(p)
		return list
	else:
		return civilian_nodes

func get_player_nodes(alive=true):
#	return player_units
	var player_nodes =  get_tree().get_nodes_in_group("player_unit")
	if alive:
		var list = []
		for p in player_nodes:
			if !p.is_dead:
				list.append(p)
		return list
	else:
		return player_nodes
func get_flying_player_nodes(alive=true):
	var player_nodes =  get_tree().get_nodes_in_group("flying_player_unit")
	if alive:
		var list = []
		for p in player_nodes:
			if !p.is_dead:
				list.append(p)
		return list
	else:
		return player_nodes

func get_enemy_nodes(alive=true):
	var enemy_nodes = get_tree().get_nodes_in_group("enemy")
	if alive:
		var list = []
		for e in enemy_nodes:
			if !e.is_dead:
				list.append(e)
		return list
	else:
		return enemy_nodes
	
func get_player_locations():
	var out = []
	for player in get_player_nodes():
		out.append(player.grid_position)
	return out

func get_civilian_locations():
	var out = []
	for civilian in get_civilian_nodes():
		out.append(civilian.grid_position)
	return out
	
	
func get_enemy_locations():
	var out = []
	for enemy in get_enemy_nodes():
		out.append(enemy.grid_position)
	return out

func get_flying_player_locations():
	var out = []
	for player in get_flying_player_nodes():
		out.append(player.grid_position)
	return out
	
func get_unwalkable_tiles():
	var unwalkable_tiles = []
	for name in unwalkable_tile_names:
		unwalkable_tiles += get_floor_tilemap().get_used_cells_by_id(get_floor_tilemap().tile_set.find_tile_by_name(name))
	return unwalkable_tiles
	

func get_obstacle_tilemap():
	return obstacle_tile_map

func get_floor_tilemap():
	return floor_tile_map
	
func get_cover_obstacles():
	var obstacles = []
	for name in cover_map.keys():
		obstacles += get_obstacle_tilemap().get_used_cells_by_id(get_obstacle_tilemap().tile_set.find_tile_by_name(name))
	return obstacles
		

func get_obstacle_locations():
	return get_cover_obstacles() + get_player_locations() + get_enemy_locations() + get_unwalkable_tiles() + get_civilian_locations()

func world_to_grid(world):
	return floor_tile_map.world_to_map(world)
func get_new_selector(scene):
	var new_selector = scene.instance()
	init_selector(new_selector)
	return new_selector
	
func init_selector(selector):
	selector.obstacle_tile_map = obstacle_tile_map
	selector.floor_tile_map = floor_tile_map

func grid_to_world(grid):
	return floor_tile_map.map_to_world(grid)
	
func cell_exists(grid):
	return floor_tile_map.get_cellv(grid) != -1
	
	
func get_cover(loc_a, loc_b):
	return cover.get_cover(loc_a, loc_b)

func get_hit_chance(loc_a, loc_b, penetration=0, ignores_cover=false, marked=false):
	if ignores_cover:
		return 0.95
	var post_pen = max(cover.get_cover(loc_a, loc_b) - penetration, 0)
	if marked:
		return min(1, hit_chance_func(post_pen) + (float(mark_acc_increase)/100))
	return hit_chance_func(post_pen)
	
func hit_chance_func(x):
	var value = 1 - log(x + 1) / log(5)
	return clamp(value, 0, 0.95)
	
func get_centre():
	var rect = floor_tile_map.get_used_rect()
	return Vector2(rect.position.x + rect.size.x / 2, rect.position.y + rect.size.y / 2)

class Cover:
	var obstacle_tile_map
	var cover_map
	
	func init(map, cov_map):
		obstacle_tile_map = map
		cover_map = cov_map
	
	static func raytrace(loc_a, loc_b):
		var tiles = []
		
		var x0 = loc_a.x
		var y0 = loc_a.y
		var x1 = loc_b.x
		var y1 = loc_b.y
		
		var dx = abs(x1 - x0);
		var dy = abs(y1 - y0);
		var x = x0;
		var y = y0;
		var n = 1 + dx + dy;
		var x_inc = 1 if (x1 > x0) else  -1;
		var y_inc =  1 if (y1 > y0) else -1;
		var error = dx - dy;
		dx *= 2;
		dy *= 2;

		while n > 0:
			tiles.append(Vector2(x, y))

			if (error > 0):
				x += x_inc;
				error -= dy;
			elif error < 0:
				y += y_inc;
				error += dx;
			elif error == 0:
				x += x_inc
				error -= dy
				y += y_inc
				error += dx
				n -= 1
			
			n -= 1
		
		return tiles

		
	func get_cover(loc_a, loc_b):
		var total_cover = 0
		for tile in raytrace(loc_a, loc_b):
			var tile_index =  obstacle_tile_map.get_cellv(tile)
			if(tile_index != -1):
				var name = obstacle_tile_map.tile_set.tile_get_name(tile_index)
				if(name in cover_map):
					total_cover += cover_map[name]

		return total_cover

class EnemySpawner:
	var wave_num = 1
	
	func spawn_enemy(_enemy_scene, _loc):
		pass
	
	func spawn_wave():
		 # var spawns = []
		wave_num += 1

	func get_empty_spawn_locations():
		pass
		
	func get_spawn_enemy_list():
		pass


