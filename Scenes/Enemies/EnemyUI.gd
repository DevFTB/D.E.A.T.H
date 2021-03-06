extends Control

var unit

func _ready():
	unit = get_parent()
	$VoiceLine.visible = false
	
	unit.connect("used_ability", self, "display_ability_voice_line")
	
func _process(_delta):
	if($VoiceLine.visible && $VoiceLineTimer.is_stopped()):
		$VoiceLine.visible = false
	
#func update_status_text():
#	$DisplayText.text = "HP: " + String(unit.health)+ ", AP: " + String(unit.action_points)

func display_voice_line(voice_line):
	$VoiceLine.text = voice_line
	$VoiceLine.visible = true
	$VoiceLineTimer.start()
	$AnimationPlayer.play("text float off")
	
func display_ability_voice_line(ability):
	if(ability.voice_lines.size() > 0):
		var index = randi() % ability.voice_lines.size()
		var voice_line = ability.voice_lines[index]
	
		display_voice_line(voice_line)
		
func display_hit_chance(hit_chance):
	$HitChanceLabel.text = String(stepify(hit_chance, 0.01) * 100) + "%"

func clear_hit_chance():
	$HitChanceLabel.text = ""

func _on_Unit_update_attr():
	$MarkedIcon.visible = unit.is_marked

func display_miss():
	$MissText.visible = true
	$MissTextAnimator.play("text float off")
	yield($MissTextAnimator, "animation_finished")
	$MissText.visible = false
	pass
