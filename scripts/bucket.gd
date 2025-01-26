extends RigidBody2D
class_name Bucket

var _yeast_count: int = 0
var _sugar_count: int = 0
var _water_count: int = 0

var _fermentation_time: float = -1.0

const READY_TIME = 180.0
const SPOIL_TIME_TOO_MUCH_INGREDIENTS = 60.0
const SPOILED_TIME = 360.0


enum State {MISSING_INGREDIENTS, FERMENTING, READY, SPOILED}
var state : State = State.MISSING_INGREDIENTS

const OPTIMAL_SUGAR_COUNT := 6
const OPTIMAL_YEAST_COUNT := 2

const MAXIMUM_SUGAR_COUNT := 10
const MAXIMUM_YEAST_COUNT := 5

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
		
	if _has_too_much_ingredients() and state == State.FERMENTING and _fermentation_time > SPOIL_TIME_TOO_MUCH_INGREDIENTS:
		_set_spoiled()
	elif _fermentation_time > SPOILED_TIME:
		_set_spoiled()
	elif _fermentation_time > READY_TIME:
		_set_ready()
		
func get_value() -> float:
	if state == State.SPOILED:
		return 0.0
	if state == State.MISSING_INGREDIENTS:
		return 0.01
		
	var value = 1.0
	value -= abs(_sugar_count - OPTIMAL_SUGAR_COUNT) / 10.0
	value -= abs(_yeast_count - OPTIMAL_YEAST_COUNT) / 10.0
	if state == State.FERMENTING:
		var too_early_multiplier = _fermentation_time / READY_TIME / 3.0
		value *= too_early_multiplier
	return value
	
func _has_too_much_ingredients():
	return _sugar_count > MAXIMUM_SUGAR_COUNT or _yeast_count > MAXIMUM_YEAST_COUNT
	
func fermentation_ongoing() -> bool:
	return _yeast_count > 0 and _sugar_count > 0 and _water_count > 0
	
func fermentation_progress() -> float:
	var time = READY_TIME
	if _has_too_much_ingredients():
		time = SPOIL_TIME_TOO_MUCH_INGREDIENTS
	return _fermentation_time / time # max 1.0
	
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
	
func too_much_sugar():
	return _sugar_count > OPTIMAL_SUGAR_COUNT
	
func not_enough_sugar():
	return _sugar_count < OPTIMAL_SUGAR_COUNT
	
func too_much_yeast():
	return _yeast_count > OPTIMAL_YEAST_COUNT
	
func not_enough_yeast():
	return _yeast_count < OPTIMAL_YEAST_COUNT
	
func too_early():
	return fermentation_progress() < 1.0
