extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.name == "Player":
		pass
		#Global.emit_signal("location_change", Global.PlayerLocation.WORLD)
