extends MarginContainer

var text: String = ""

@onready var label : Label = $"TextLabel" 
func play_text(sent_text: String):
	$Timer.start()
	
	if self.visible && text == sent_text:
		return
	label.visible_ratio = 0
	self.visible = true
	label.text = sent_text
	
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1, 1)
	await get_tree().create_timer(2).timeout


func _on_timer_timeout():
	self.visible = false
