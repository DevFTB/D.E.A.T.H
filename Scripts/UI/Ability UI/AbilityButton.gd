extends TextureButton
class_name AbilityButton

var player
var ability_index

onready var lifecycle_manager = get_node("/root/World/AbilityLifecycleManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_normal = player.abilities[ability_index].icon
	var _conn = connect("pressed", self, "_on_Ability_Button_pressed")
	
	set_state()

func set_state():
	if (!player.abilities[ability_index].can_use_ability(player)):
			disabled = true
			modulate = Color("#282828")
			
func _on_Ability_Button_pressed():
	lifecycle_manager.submit_ability(player, ability_index)
	SoundEngine.play_button_sound()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
