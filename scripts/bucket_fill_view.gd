extends Control

@onready var _yeast_sprite: TextureRect = $"TextureRect/YeastTexture"
@onready var _sugar_sprite: TextureRect = $"TextureRect/SugarTexture"
@onready var _ingredient_target_location: Node2D = $"IngredientTargetPosition"
@onready var _ingredient_start_location: Node2D = $"IngredientStartPosition"
@onready var _audio_player : AudioStreamPlayer2D = $"AudioStreamPlayer2D"

var _rng : RandomNumberGenerator = RandomNumberGenerator.new()
var _bucket : Bucket = null

signal closed
signal use_item

func _process(delta: float):
	
	if not visible:
		return
	
	if Input.is_action_just_pressed("player_cancel"):
		_bucket = null
		closed.emit()
		return
		
func _get_ingredient(sprite: TextureRect):
	var copy = sprite.duplicate()
	copy.position = _ingredient_start_location.position
	copy.rotation = _rng.randf_range(-1.0, 1.0)
	add_child(copy)
	return copy
	
func _add_ingredient(sprite: TextureRect):
	var ingredient = _get_ingredient(sprite)
	ingredient.show()
	_audio_player.play()
	var tween_pos = create_tween()
	var tween_rot = create_tween()
	tween_pos.tween_property(ingredient, "position", _ingredient_target_location.position, 0.25)
	tween_rot.tween_property(ingredient, "rotation", randf_range(-1.0, 1.0), 0.25)
	await tween_pos.finished
	await get_tree().create_timer(0.05).timeout
	ingredient.queue_free()

func add_yeast() -> void:
	if not _bucket:
		printerr("ei oo ämpäriä perkele")
		return
	_bucket.add_yeast(1)
	_add_ingredient(_yeast_sprite)

func add_sugar() -> void:
	if not _bucket:
		printerr("ei oo ämpäriä perkele")
		return
	_bucket.add_sugar(1)
	_add_ingredient(_sugar_sprite)

func _on_player_bucket_inspected(bucket: Bucket) -> void:
	_bucket = bucket

func _on_inventory_menu_item_used(id: Item.Id) -> void:
	match id:
		Item.Id.YEAST:
			add_yeast()
		Item.Id.SUGAR:
			add_sugar()
