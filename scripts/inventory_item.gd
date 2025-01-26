extends PanelContainer

@onready var select_overlay: TextureRect = $"SelectOverlay"
@onready var select_rect: ColorRect = $"TextureRect/ColorRect"

var active: bool = false
var item: Item = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select_rect.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_active(value: bool):
	active = value
	if active:
		select_overlay.show()
		select_rect.visible = true
		#modulate = Color(255,255,255,1.0)
	else:
		select_rect.visible = false
		select_overlay.hide()
