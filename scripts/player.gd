extends CharacterBody2D

@export var inventory: Inventory
@onready var action_indicator : Sprite2D = $"ActionIndicatorSprite"

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

enum Action {NONE, BUY_YEAST}

var current_action: Action = Action.NONE

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

func _update_action_indicator():
	if velocity.x > 0:
		action_indicator.position.x = 28
		action_indicator.position.y = 0
	elif velocity.x < 0:
		action_indicator.position.x = -28
		action_indicator.position.y = 0
	if velocity.y > 0:
		action_indicator.position.y = 28
		action_indicator.position.x = 0
	elif velocity.y < 0:
		action_indicator.position.y = -28
		action_indicator.position.x = 0


func _on_action_indicator_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if len(area.get_groups()) == 0:
		printerr("grouppi puuttuu action target arealta")
	var group = area.get_groups()[0]
	if group == "yeast_buy_zone":
		current_action = Action.BUY_YEAST
		
func _on_action_indicator_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	current_action = Action.NONE
	
func _act():
	match current_action:
		Action.NONE:
			return
		Action.BUY_YEAST:
			printerr("DEWA: OSTA SITÄ VITUN HIIVAA :D")		
