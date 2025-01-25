extends RigidBody2D
class_name Bucket

var _yeast_count: int = 0
var _sugar_count: int = 0
var _water_count: int = 0

var _fermentation_start_time: int = 0

const READY_TIME = 60*1000
const SPOILED_TIME = 300*1000

enum State {MISSING_INGREDIENTS, FERMENTING, READY, SPOILED}
var state : State = State.MISSING_INGREDIENTS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == State.SPOILED:
		return
	
	if _fermentation_ongoing() and state == State.MISSING_INGREDIENTS:
		_fermentation_start_time = Time.get_ticks_msec()
		state = State.FERMENTING
	
	var fermentation_time = Time.get_ticks_msec() - _fermentation_start_time
	if fermentation_time > SPOILED_TIME:
		_set_spoiled()
	elif fermentation_time > READY_TIME:
		_set_ready()
	
func _fermentation_ongoing() -> bool:
	return _yeast_count > 0 and _sugar_count > 0 and _water_count > 0
	
func _set_ready():
	state = State.READY

func _set_spoiled():
	state = State.SPOILED

func add_yeast(count: int):
	_yeast_count += count
	
func add_sugar(count: int):
	_sugar_count += count
	
func add_water(count: int):
	_water_count += count
