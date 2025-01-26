extends Node2D
class_name SpeechBubble

var text: String = ""
@onready var label : Label = $"TextLabel" 
@onready var id : String = $"..".id

func _ready():
	label.visible_ratio = 0
	SignalManager.receive_speak.connect(_on_speak)

	
func play_text(text: String):
	
	if self.visible:
		return
		
	self.visible = true
	label.text = text
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1, 1)
	await get_tree().create_timer(2).timeout
	label.visible_ratio = 0
	self.visible = false

func _on_speak(speak_id: String, text: String):
	if id == speak_id:
		play_text(text)
