extends RigidBody2D
class_name Bucket

var _yeast_count: int = 0
var _sugar_count: int = 0
var _water_count: int = 0

var _fermentation_time: float = -1.0

const READY_TIME = 180.0
const SPOILED_TIME = 360.0

enum State {MISSING_INGREDIENTS, FERMENTING, READY, SPOILED}
var state : State = State.MISSING_INGREDIENTS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == State.SPOILED:
		return
	
	if _fermentation_time >= 0.0:
		_fermentation_time += delta
		
	if fermentation_ongoing() and state == State.MISSING_INGREDIENTS:
		_fermentation_time = 0.00001
		state = State.FERMENTING
	
	if _fermentation_time > SPOILED_TIME:
		_set_spoiled()
	elif _fermentation_time > READY_TIME:
		_set_ready()
	
func fermentation_ongoing() -> bool:
	return _yeast_count > 0 and _sugar_count > 0 and _water_count > 0
	
func fermentation_progress() -> float:
	return _fermentation_time / READY_TIME # max 1.0
	
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
