extends Node2D
@export var id: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	SignalManager.send_speak.emit(id, SignalManager.speak_actions.BUYING_PRODUCT)


func _on_game_bucket_sold(bucket: Bucket) -> void:
	var voicelines = []
	if bucket.not_enough_sugar():
		voicelines.append(SignalManager.speak_actions.NOT_ENOUGH_SUGAR)
	if bucket.too_much_sugar():
		voicelines.append(SignalManager.speak_actions.TOO_MUCH_SUGAR)
	if bucket.not_enough_yeast():
		voicelines.append(SignalManager.speak_actions.NOT_ENOUGH_YEAST)
	if bucket.too_much_yeast():
		voicelines.append(SignalManager.speak_actions.TOO_MUCH_YEAST)
	if bucket.too_early():
		voicelines.append(SignalManager.speak_actions.PRODUCT_TOO_EARLY)
	if bucket.state == Bucket.State.SPOILED:
		voicelines.append(SignalManager.speak_actions.PRODUCT_SPOILED)
	if bucket.get_value() > 0.99:
		voicelines.append(SignalManager.speak_actions.PRODUCT_PERFECT)
	var selection = voicelines.pick_random()
	SignalManager.send_speak.emit(id, selection)
