extends CharacterBody2D

@onready var action_indicator : Sprite2D = $"ActionIndicatorSprite"

@onready var yeast_scene = preload("res://scenes/items/yeast.tscn")
@onready var sugar_scene = preload("res://scenes/items/sugar.tscn")
@onready var bucket_scene = preload("res://scenes/items/bucket.tscn")

@onready var raycast : RayCast2D = $"RayCast2D"

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

enum Action {NONE, BUY_YEAST, BUY_SUGAR, BUY_BUCKET, PICKUP}

var _current_action: Action = Action.NONE
var _current_action_target: Node2D = null
var _carrying_item: Node2D = null
var _ray_length : int = 0

@export var inventory: Inventory

func _ready():
	_ray_length = raycast.target_position.x

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
		
	if Input.is_action_just_pressed("player_action"):
		_act()

	move_and_slide()
	_update_action_indicator()
	_update_carrying_item()

func _update_carrying_item() -> void:
	if _carrying_item:
		_carrying_item.global_position = to_global(action_indicator.position)

func _update_action_indicator():
	if velocity.x > 0:
		action_indicator.position.x = 26
		raycast.target_position.x = _ray_length
	elif velocity.x < 0:
		action_indicator.position.x = -26
		raycast.target_position.x = -_ray_length
	elif velocity.y != 0:
		action_indicator.position.x = 0
		raycast.target_position.x = 0
	if velocity.y > 0:
		action_indicator.position.y = 26
		raycast.target_position.y = _ray_length
	elif velocity.y < 0:
		action_indicator.position.y = -26
		raycast.target_position.y = -_ray_length
	elif velocity.x != 0:
		action_indicator.position.y = 0
		raycast.target_position.y = 0
		


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
	if group == "bucket_pickup_zone":
		_current_action = Action.PICKUP
		
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


func _act():
	# If carrying an item, need to drop it first
	if _carrying_item:
		_try_drop_carrying_item()
		return
	match _current_action:
		Action.NONE:
			return
		Action.BUY_YEAST:
			var yeast = self._new_yeast()
			inventory.add_item(yeast, 1)	
		Action.BUY_SUGAR:
			var sugar = self._new_sugar()
			inventory.add_item(sugar, 1)
		Action.BUY_BUCKET:
			var bucket = self._new_bucket()
			inventory.add_item(bucket, 1)
		Action.PICKUP:
			if _carrying_item == null:
				_carrying_item = _current_action_target
				var collision_object = _get_collision_object(_carrying_item)
				if collision_object:
					raycast.add_exception(collision_object)
				
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
