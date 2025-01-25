extends Node2D

@onready var shop_spawn_point = $ShopSpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_shop_door_entered(body:Node2D) -> void:
	if body.name == "Player":
		print("vaihda positio")
