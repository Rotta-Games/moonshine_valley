extends Resource
class_name Item

@export var name: String
@export var description: String
@export var ui_icon: Texture
@export var stackable: bool
@export var stack_size: int # <= 0 means infinity

# Link to the corresponding pickable item scene, if you need to drop the item back on the floor
@export_file("*.tscn") var pickable_item_scene

var item_scene: PackedScene
