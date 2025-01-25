extends CharacterBody2D

@onready var action_indicator : Sprite2D = $"ActionIndicatorSprite"

@onready var yeast_scene = preload("res://scenes/items/yeast.tscn")
@onready var sugar_scene = preload("res://scenes/items/sugar.tscn")
@onready var bucket_scene = preload("res://scenes/items/bucket.tscn")

@onready var money_label = %MoneyAmount

@onready var raycast : RayCast2D = $"RayCast2D"

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const DRAG_FRAMES_THRESHOLD = 6

enum Action {NONE, BUY_YEAST, BUY_SUGAR, BUY_BUCKET, ACT_BUCKET}

var _current_action: Action = Action.NONE
var _current_action_target: Node2D = null
var _carrying_item: Node2D = null
var _ray_length : int = 0

var _action_button_frame_count: int = false

var money_amount_cents: int = 5_00: set = _update_money_label

var yeast_price_cents: int = 25
var sugar_price_cents: int = 1_50
var bucket_price_cents: int = 10_00

@export var inventory: Inventory

func _ready():
	_ray_length = int(raycast.target_position.x)
	money_label.text = str(money_amount_cents/100.0) + "€"


func _physics_process(delta: float) -> void:
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
		
	if Input.is_action_pressed("player_action"):
		_act_press()
		_action_button_frame_count += 1
	if Input.is_action_just_released("player_action"):
		_act_release()
		_action_button_frame_count = 0
		
	var cur_pos = position

	move_and_slide()
	_update_action_indicator()
	_update_carrying_item(cur_pos)

func _update_carrying_item(old_pos: Vector2) -> void:
	var pos_delta = position - old_pos
	if _carrying_item:
		_carrying_item.global_position += pos_delta
		raycast.rotation = global_position.angle_to_point(_carrying_item.global_position)

func _update_action_indicator():
	if velocity.x > 0:
		action_indicator.position.x = 20
	elif velocity.x < 0:
		action_indicator.position.x = -20
	elif velocity.y != 0:
		action_indicator.position.x = 0
	if velocity.y > 0:
		action_indicator.position.y = 20
	elif velocity.y < 0:
		action_indicator.position.y = -20
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
		_current_action = Action.BUY_YEAST
	if group == "sugar_buy_zone":
		_current_action = Action.BUY_SUGAR
	if group == "bucket":
		_current_action = Action.ACT_BUCKET
		
func _on_action_indicator_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	_current_action = Action.NONE


func _new_yeast():
	var item = Item.new()
	item.name = "Hiiva"
	item.description = "Hiivaa"
	item.item_scene = yeast_scene
	return item


func _new_bucket():
	var item = Item.new()
	item.name = "Änpäri"
	item.description = "Tyhjä"
	item.item_scene = bucket_scene
	return item


func _new_sugar():
	var item = Item.new()
	item.name = "Hiiva"
	item.description = "Hiivaa"
	item.item_scene = yeast_scene
	return item


func _act_press():
	match _current_action:
		Action.NONE:
			return
		Action.BUY_YEAST:
			if money_amount_cents < yeast_price_cents:
				return
			var yeast = self._new_yeast()
			var ok = inventory.add_item(yeast, 1)
			if ok:
				money_amount_cents -= yeast_price_cents
		Action.BUY_SUGAR:
			if money_amount_cents < sugar_price_cents:
				return
			var sugar = self._new_sugar()
			var ok = inventory.add_item(sugar, 1)
			if ok:
				money_amount_cents -= sugar_price_cents
		Action.BUY_BUCKET:
			if money_amount_cents < bucket_price_cents:
				return
			var bucket = self._new_bucket()
			var ok = inventory.add_item(bucket, 1)
			if ok:
				money_amount_cents -= bucket_price_cents
		Action.ACT_BUCKET:
			if _carrying_item == null and _action_button_frame_count >= DRAG_FRAMES_THRESHOLD:
				_carrying_item = _current_action_target
				var collision_object = _get_collision_object(_carrying_item)
				if collision_object:
					raycast.add_exception(collision_object)

					
func _act_release():
	# If carrying an item, need to drop it first
	if _carrying_item:
		_try_drop_carrying_item()
		return
	match _current_action:
		Action.ACT_BUCKET:
			print(_action_button_frame_count)
			if _action_button_frame_count < DRAG_FRAMES_THRESHOLD:
				print("JONI: aukase se zoomi ikkuna :D")



func _get_collision_object(parent : Node2D):
	for child in parent.get_children():
		if child is CollisionObject2D:
			return child
	return null

func _try_drop_carrying_item():
	if not raycast.is_colliding():
		_carrying_item = null
		_current_action_target = null
		_current_action = Action.NONE
		raycast.clear_exceptions()


func _update_money_label(value) -> void:
	money_label.text = str(value/100.0) + "€"
	money_amount_cents = value
