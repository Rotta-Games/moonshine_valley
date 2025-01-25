extends Control

func _update_text(amount: int) -> void:
	self.text = str(amount / 100.0) + "€"
