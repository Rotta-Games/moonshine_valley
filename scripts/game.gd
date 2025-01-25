extends Node2D

@onready var _bucket_fill_view: Control = $"WindowCanvasLayer/BucketFillView"

signal bucket_sold(bucket_state: Bucket.State)

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


func _on_bucket_entered_selling_area(body: Node2D) -> void:
	if body is Bucket:
		print("VOITIT PELIN :D")
		bucket_sold.emit(body.state)
		body.queue_free()
