extends Control

@onready var texture : TextureRect = $"TextureRect"
@onready var audio_player : AudioStreamPlayer2D = $"AudioStreamPlayer2D"
@onready var timer : Timer = $"Timer"

var _animation_playing: bool = false

const FRAME_WIDTH := 160
const FRAME_COUNT = 7
const TIME_PER_FRAME := 0.09
var cur_frame_time := 0.0
var _bucket : Bucket = null
signal closed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not visible:
		return
	
	if Input.is_action_just_pressed("player_cancel"):
		_bucket = null
		closed.emit()
		return
		
	if not _bucket:
		return
	
	var bucket_progress = _bucket.fermentation_progress()
	_check_bucket_progress(bucket_progress)
	_check_frame(delta)

func _check_bucket_progress(progress):
	if not timer.is_stopped():
		return
	var next_plup = 4 * exp(1.99 * progress)
	print(next_plup)
	timer.start(next_plup)
		
func _check_frame(delta: float):
	if not _animation_playing:
		return
	cur_frame_time += delta
	var has_next_frame = true
	if cur_frame_time >= TIME_PER_FRAME:
		cur_frame_time -= TIME_PER_FRAME
		has_next_frame = _next_frame()
		if not audio_player.is_playing():
			audio_player.play()
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

func _on_timer_timeout() -> void:
	_play_animation()
	
func _on_player_bucket_inspected(bucket: Bucket) -> void:
	_bucket = bucket
