extends Camera2D

@onready var target = get_node("../Player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# godot 4.3
	# move camera with player
	self.position = lerp(self.position, target.position, delta * 10)
