extends Node

signal location_change

enum PlayerLocation { WORLD, SHOP }

var player_location: PlayerLocation = PlayerLocation.WORLD

var location_scene_map = {
	PlayerLocation.WORLD: "res://scenes/world.tscn",
	PlayerLocation.SHOP: "res://scenes/shop/shop.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("location_change", on_location_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_location_change(new_location: PlayerLocation):
	get_tree().change_scene_to_file(location_scene_map[new_location])


func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
