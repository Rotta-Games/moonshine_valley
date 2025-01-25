extends PanelContainer

@onready var unselect_overlay: ColorRect = $"UnselectOverlay"

var active: bool = false
var item: Item = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_active(value: bool):
	active = value
	if active:
		unselect_overlay.hide()
	else:
		unselect_overlay.show()
