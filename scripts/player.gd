extends CharacterBody2D

@onready var action_indicator : Sprite2D = $"ActionIndicatorSprite"

@onready var yeast_scene = preload("res://scenes/items/yeast.tscn")

@onready var raycast : RayCast2D = $"RayCast2D"

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

enum Action {NONE, BUY_YEAST, BUY_SUGAR, PICKUP}

var _current_action: Action = Action.NONE
var _current_action_target: Node2D = null
var _carrying_item: Node2D = null
var _ray_length : int = 0

func _ready():
	_ray_length = raycast.target_position.x

func _physics_process(delta: float) -> void:
	var h_direction := Input.get_axis("move_left", "move_right")
	if h_direction:
		velocity.x = h_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var v_direction := Input.get_axis("move_up", "move_down")
	if v_direction:
		velocity.y = v_direction * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
		
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
	
func _act():
	# If carrying an item, need to drop it first
	if _carrying_item:
		_try_drop_carrying_item()
		return
	match _current_action:
		Action.NONE:
			return
		Action.BUY_YEAST:
			var yeast = Item.new()
			yeast.name = "Hiiva"
			yeast.description = "Hiivaa"
			yeast.item_scene = yeast_scene
			Inventory.add_item(yeast, 1)	
		Action.BUY_SUGAR:
			printerr("DEWA: OSTA SITÄ SOKERIA :DDD")		
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
