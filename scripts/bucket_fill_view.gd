extends Control

@onready var _yeast_sprite: TextureRect = $"TextureRect/YeastTexture"
@onready var _sugar_sprite: TextureRect = $"TextureRect/SugarTexture"
@onready var _ingredient_target_location: Node2D = $"IngredientTargetPosition"
@onready var _ingredient_start_location: Node2D = $"IngredientStartPosition"

var _animation_playing: bool = false
var _rng : RandomNumberGenerator = RandomNumberGenerator.new()
var _bucket : Bucket = null
var _next_plup_tick = 0

signal closed

func _process(delta: float):
	if Input.is_action_just_pressed("player_cancel"):
		_bucket = null
		closed.emit()
		return
		
	if _bucket and _is_plup_time():
		_play_plup_sound()
		
func _is_plup_time() -> bool:
	return false
	
func _play_plup_sound():
	pass
		
func _reset_ingredient(sprite: TextureRect):
	sprite.position = _ingredient_start_location.position
	sprite.rotation = _rng.randf_range(-1.0, 1.0)
	
func _add_ingredient(sprite: TextureRect):
	if _animation_playing:
		return
	_animation_playing = true
	_reset_ingredient(sprite)
	sprite.show()
	var tween_pos = create_tween()
	var tween_rot = create_tween()
	tween_pos.tween_property(sprite, "position", _ingredient_target_location.position, 0.3)
	tween_rot.tween_property(sprite, "rotation", randf_range(-1.0, 1.0), 0.3)
	await tween_pos.finished
	await get_tree().create_timer(0.1).timeout
	sprite.hide()
	_animation_playing = false

func add_yeast() -> void:
	_add_ingredient(_yeast_sprite)

func add_sugar() -> void:
	_add_ingredient(_sugar_sprite)

func _on_player_bucket_inspected(bucket: Bucket) -> void:
	_bucket = bucket
	print(bucket.state)
