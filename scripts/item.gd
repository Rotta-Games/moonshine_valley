extends Resource
class_name Item

@export var name: String
@export var description: String
@export var ui_icon: Texture2D
@export var stackable: bool
@export var stack_size: int # <= 0 means infinity

var item_scene: PackedScene
