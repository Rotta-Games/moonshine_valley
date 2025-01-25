extends Node2D

@export var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var pos_diff = target.global_position - body.global_position
		body.global_position += pos_diff
		if body._carrying_item:
			body._carrying_item.global_position += pos_diff
