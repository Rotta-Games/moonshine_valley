extends Node

var text: String = ""

@onready var label : Label = $"TextLabel" 

func _ready():
	SignalManager.send_help_text.connect(_on_send_help_text)

func play_text(sent_text: String):
	$Timer.start()
	
	if label.visible && text == sent_text:
		return
	label.visible_ratio = 0
	label.visible = true
	label.text = sent_text
	
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1, 1)
	await get_tree().create_timer(3).timeout


func _on_timer_timeout():
	label.visible = false

func _on_send_help_text(text: String):
	play_text(text)
	
