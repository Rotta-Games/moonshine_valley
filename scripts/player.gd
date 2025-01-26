extends CharacterBody2D

signal money_changed(amount: int)
signal bucket_inspected(bucket: Bucket)
signal pause_button_pressed()

@onready var action_indicator : Sprite2D = $"ActionIndicatorSprite"

@onready var yeast_scene = preload("res://scenes/items/yeast.tscn")
@onready var sugar_scene = preload("res://scenes/items/sugar.tscn")
@onready var bucket_scene = preload("res://scenes/items/bucket.tscn")
@onready var bottle_scene = preload("res://scenes/items/bottle.tscn")
@onready var bucket_object_scene = preload("res://scenes/objects/bucket.tscn")
@onready var raycast : RayCast2D = $"RayCast2D"

@export var bucket_container: Node2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

const ACTION_HOLD_TIME_THRESHOLD = 0.05
const ACTION_TAP_TIME_THRESHOLD = 0.8

const START_MOENY = 100_00

enum Action {NONE, BUY_YEAST, BUY_SUGAR, BUY_BUCKET, ACT_BUCKET, FILL_BUCKET}

var _current_action: Action = Action.NONE
var _current_action_target: Node2D = null

var _to_be_carrying: bool = false
var _carrying_item: Node2D = null
var _ray_length : int = 0

var _action_button_timer: float = false
var _action_button_hold: bool = false

var money_amount_cents: int: set = _update_money

var yeast_price_cents: int = 25
var sugar_price_cents: int = 1_50
var bucket_price_cents: int = 10_00

@onready var yeast_item = yeast_scene.instantiate()
@onready var bucket_item = bucket_scene.instantiate()
@onready var sugar_item = sugar_scene.instantiate()
@onready var bottle_item = bottle_scene.instantiate()


@export var inventory: Inventory

func _ready():
	_ray_length = int(raycast.target_position.x)
	money_amount_cents = START_MOENY


func _input(event):
	if event.is_action_pressed("quit"):
		pause_button_pressed.emit()

	if event.is_action_pressed("player_action"):
		_action_button_timer = 0
	if event.is_action_released("player_action"):
		if _action_button_hold:
			_action_button_hold = false
			_act_release()
		else:
			_act_tap()


func _process(delta: float) -> void:
	if Input.is_action_pressed("player_action"):
		_action_button_timer += delta
		if not _action_button_hold and _action_button_timer >= ACTION_HOLD_TIME_THRESHOLD:
			_action_button_hold = true
			_act_hold()

	if self.velocity.length() > 0 and _carrying_item == null and _to_be_carrying:
		_carrying_item = _current_action_target
		_to_be_carrying = false
		if _carrying_item:
			raycast.add_exception(_carrying_item)


func _physics_process(_delta: float) -> void:
	var move_speed = SPEED
	if Input.is_action_pressed("debug_run"):
		move_speed *= 2
	if _carrying_item:
		move_speed /= 2
	var h_direction := Input.get_axis("move_left", "move_right")
	if h_direction:
		velocity.x = h_direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	var v_direction := Input.get_axis("move_up", "move_down")
	if v_direction:
		velocity.y = v_direction * move_speed
	else:
		velocity.y = move_toward(velocity.x, 0, move_speed)
		
	var cur_pos = position

	move_and_slide()
	_update_action_indicator()
	_update_carrying_item(cur_pos)

func _update_carrying_item(old_pos: Vector2) -> void:
	var pos_delta = position - old_pos
	if _carrying_item and is_instance_valid(_carrying_item):
		_carrying_item.global_position += pos_delta
		raycast.rotation = global_position.angle_to_point(_carrying_item.global_position)

func _update_action_indicator():
	if velocity.x > 0:
		action_indicator.position.x = 18
	elif velocity.x < 0:
		action_indicator.position.x = -18
	elif velocity.y != 0:
		action_indicator.position.x = 0
	if velocity.y > 0:
		action_indicator.position.y = 20
	elif velocity.y < 0:
		action_indicator.position.y = -12
	elif velocity.x != 0:
		action_indicator.position.y = 0
		


func _on_action_indicator_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if len(area.get_parent().get_groups()) == 0:
		printerr("grouppi puuttuu action target arealta")
	if _carrying_item:
		return
	_current_action_target = area.get_parent()
	var group = area.get_parent().get_groups()[0]
	if group == "yeast_buy_zone":
		SignalManager.send_help_text.emit(yeast_item.item.description)
		_current_action = Action.BUY_YEAST
	if group == "sugar_buy_zone":
		SignalManager.send_help_text.emit(sugar_item.item.description)
		_current_action = Action.BUY_SUGAR
	if group == "bucket_buy_zone":
		SignalManager.send_help_text.emit(bucket_item.item.description)
		_current_action = Action.BUY_BUCKET
	if group == "bucket":
		_current_action = Action.ACT_BUCKET
	if group == "bucket_fill_zone":
		_current_action = Action.FILL_BUCKET
		
func _on_action_indicator_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	_current_action = Action.NONE
	_current_action_target = null
	_to_be_carrying = false

func _act_tap():
	match _current_action:
		Action.NONE:
			return
		Action.BUY_YEAST:
			if money_amount_cents < yeast_price_cents:
				SignalManager.send_speak.emit('SHALEPA', SignalManager.speak_actions.NO_MONEY)
				return

			var ok = inventory.add_item(yeast_item.item, 1)
			
			if ok:
				money_amount_cents -= yeast_price_cents
				SignalManager.send_speak.emit('SHALEPA', SignalManager.speak_actions.YEAST)
			
		Action.BUY_SUGAR:
			if money_amount_cents < sugar_price_cents:
				SignalManager.send_speak.emit('SHALEPA', SignalManager.speak_actions.NO_MONEY)
				return
			var ok = inventory.add_item(sugar_item.item, 1)
			if ok:
				money_amount_cents -= sugar_price_cents
				SignalManager.send_speak.emit('SHALEPA', SignalManager.speak_actions.SUGAR)
		Action.BUY_BUCKET:
			if money_amount_cents < bucket_price_cents:
				SignalManager.send_speak.emit('DOKMANNI', SignalManager.speak_actions.NO_MONEY)
				return
			var ok = inventory.add_item(bucket_item.item, 1)
			if ok:
				money_amount_cents -= bucket_price_cents
				SignalManager.send_speak.emit('DOKMANNI', SignalManager.speak_actions.BUCKET)
		Action.ACT_BUCKET:
			bucket_inspected.emit(_current_action_target as Bucket)
			_to_be_carrying = false
		Action.FILL_BUCKET:
			if inventory.get_item_amount(bucket_item.item) > 0:
				var bucket = bucket_object_scene.instantiate()
				bucket.global_position = action_indicator.global_position
				inventory.remove_item(bucket_item.item, 1)
				bucket.add_water(100)
				bucket_container.add_child(bucket)

func _act_hold():
	match _current_action:
		Action.ACT_BUCKET:
			if _carrying_item == null:
				_to_be_carrying = true

func _act_release():
	# If carrying an item, need to drop it first
	if _carrying_item:
		_try_drop_carrying_item()
		return
	else:
		# allow tap for a longer time if not carrying an item
		if _action_button_timer < ACTION_TAP_TIME_THRESHOLD:
			_act_tap()


func _try_drop_carrying_item():
	if not raycast.is_colliding():
		_carrying_item = null
		_current_action_target = null
		_current_action = Action.NONE
		raycast.clear_exceptions()

func _update_money(value) -> void:
	money_amount_cents = value
	money_changed.emit(money_amount_cents)


func _on_bucket_sold(bucket_value: float) -> void:
	print("gaining money: " + str(50_00 * bucket_value))
	money_amount_cents += 50_00 * bucket_value


func add_bottle():
	inventory.add_item(bottle_item.item, 1)	


func sell_bottles() -> bool:
	var bottle_amount = inventory.get_item_amount(bottle_item.item)

	if bottle_amount == 0:
		return false

	inventory.remove_item(bottle_item.item, -1)
	money_amount_cents += bottle_amount * 0_20

	return true
