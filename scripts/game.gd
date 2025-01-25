extends Node2D

@onready var _bucket_fill_view: Control = $"WindowCanvasLayer/BucketFillView"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_bucket_inspected(bucket: Bucket) -> void:
	_bucket_fill_view.show()
	get_tree().paused = true

func _on_bucket_fill_view_closed() -> void:
	get_tree().paused = false
	_bucket_fill_view.hide()
