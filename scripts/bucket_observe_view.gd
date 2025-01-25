extends Control

@onready var texture : TextureRect = $"TextureRect"

var _animation_playing: bool = false

const FRAME_WIDTH := 160
const FRAME_COUNT = 7
const TIME_PER_FRAME := 0.09
var cur_frame_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _animation_playing:
		return
	cur_frame_time += delta
	var has_next_frame = true
	if cur_frame_time >= TIME_PER_FRAME:
		cur_frame_time -= TIME_PER_FRAME
		has_next_frame = _next_frame()
	if not has_next_frame:
		_animation_playing = false
		
func _next_frame() -> bool:
	texture.texture.atlas.region.position.x += FRAME_WIDTH
	if texture.texture.atlas.region.position.x >= FRAME_COUNT * FRAME_WIDTH:
		texture.texture.atlas.region.position.x = FRAME_WIDTH # first frame reserved for other use
		return false
	return true

func _play_animation() -> void:
	_reset_frame()
	_animation_playing = true
	
func _reset_frame():
	cur_frame_time = 0
