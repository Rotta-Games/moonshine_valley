extends Node2D

@onready var _bucket_fill_view: Control = $"WindowCanvasLayer/BucketFillView"
@onready var _bucket_observe_view: Control = $"WindowCanvasLayer/BucketObserveView"
@onready var _inventory_menu := $"WindowCanvasLayer/InventoryMenu"

signal bucket_sold(bucket_value: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_bucket_inspected(bucket: Bucket) -> void:
	if bucket.fermentation_ongoing():
		_bucket_observe_view.show()
	else:
		_inventory_menu.enable(true)
		_bucket_fill_view.show()
	get_tree().paused = true

func _on_bucket_fill_view_closed() -> void:
	get_tree().paused = false
	_bucket_fill_view.hide()
	_bucket_observe_view.hide()
	_inventory_menu.enable(false)

func _on_bucket_entered_selling_area(body: Node2D) -> void:
	if body is Bucket:
		bucket_sold.emit(body.get_value())
		body.queue_free()
