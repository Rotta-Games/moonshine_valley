extends Node2D

@onready var player = $Player
@onready var player_cam = $PlayerCamera
@onready var shop_spawn_point = $ShopSpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.player_location == Global.PlayerLocation.SHOP:
		player.position = shop_spawn_point.position

	Global.player_location = Global.PlayerLocation.WORLD

	player_cam.position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_shop_door_entered(body:Node2D) -> void:
	if body.name == "Player":
		Global.emit_signal("location_change", Global.PlayerLocation.SHOP)
