extends Node

var rng = RandomNumberGenerator.new()

var combat_music = load("res://Assets/Sounds/Music/DEATH.wav")
var menu_music = load("res://Assets/Sounds/Music/DEATHmainmenu.wav")
var cinematic_music = load("res://Assets/Sounds/Music/DEATHcinematic.wav")

#sfx goes here:

#abilities:
var fire_weapon_rifle = load("res://Assets/Sounds/SFX/Weapon Sounds/riflesfx.mp3")
# var fire_weapon_machinegun = load("")
var fire_weapon_sniper = load("res://Assets/Sounds/SFX/Weapon Sounds/snipersfx.mp3")
var medic_heal = load("res://Assets/Sounds/SFX/Player/playerheal.wav")
# var evacuate_sfx = load("")

#enemies:
var enemy_hurt_sfx = load("res://Assets/Sounds/SFX/Enemy/enemyhurt.wav")
var enemy_death_sfx = load("res://Assets/Sounds/SFX/Enemy/enemydeath.wav")
var explosion_sfx = load("res://Assets/Sounds/SFX/Weapon Sounds/explosion.wav")

#other:
var footsteps = load("res://Assets/Sounds/SFX/Player/running sfx.wav")
var civilian_screams = load ("res://Assets/Sounds/SFX/Civilians/civilianscreams.wav")
var button_sfx = load ("res://Assets/Sounds/SFX/UI/buttonpresssfx.wav")
var player_hurt_sfx = load ("res://Assets/Sounds/SFX/Player/playerhurt.wav")
var player_hurt_sfx2 = load ("res://Assets/Sounds/SFX/Player/hurt sound 2.wav")
var player_hurt_sfx3 = load ("res://Assets/Sounds/SFX/Player/hurt sound 1.wav")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func stop_sfxPlayer():
	$SfxPlayer.stop()
	
func play_enemyDeath_sfx():
	$SfxEnemy.stream = enemy_death_sfx
	$SfxEnemy.play()

func play_fire_rifle_sfx():
	$SfxPlayerWeapon.stream = fire_weapon_rifle
	$SfxPlayerWeapon.play()

func play_enemy_rifle_sfx():
	$SfxEnemyWeapon.stream = fire_weapon_rifle
	$SfxEnemyWeapon.play()
	
#func play_fire_machinegun_sfx():
#	$SfxPlayerWeapon.stream = fire_weapon_machinegun
#	$SfxPlayerWeapon.play()

func play_fire_sniper_sfx():
	$SfxPlayerWeapon.stream = fire_weapon_sniper
	$SfxPlayerWeapon.play()

func play_combat_music():
	$GameMusic.stream = combat_music
	$GameMusic.play()
	
func play_menu_music():
	$GameMusic.stream = menu_music
	$GameMusic.play()

func play_cinematic_music():
	$GameMusic.stream = cinematic_music
	$GameMusic.play()
	
func play_explosion_sfx():
	$SfxEnemyWeapon.stream = explosion_sfx
	$SfxEnemyWeapon.play()

func play_footsteps_sfx():
	$SfxPlayer.stream = footsteps
	$SfxPlayer.play()
	
func play_civilian_scream():
	$SfxCivilian.stream = civilian_screams
	$SfxCivilian.play()
	
func play_button_sound():
	$SfxUI.stream = button_sfx
	$SfxUI.play()
	
func play_playerhurt_sfx():

	var my_random_number = randi() % 2
	
	if my_random_number == 0 :
		$SfxPlayer.stream = player_hurt_sfx2
	if my_random_number == 1 :
		$SfxPlayer.stream = player_hurt_sfx3	
	$SfxPlayer.play()
	
func play_enemyHurt_sfx():
	$SfxEnemy.stream = enemy_hurt_sfx
	$SfxEnemy.play()
	
func play_medicHeal():
	$SfxPlayerWeapon.stream = medic_heal
	$SfxPlayerWeapon.play()
