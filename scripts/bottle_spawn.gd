extends Node2D


@onready var bottle_scene = preload("res://scenes/objects/bottle.tscn")
@onready var area = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func spawn_bottle() -> void:
	if randf() > 0.2:
		return

	var bottle = bottle_scene.instantiate()
	bottle.position.x = round(randf() * area.shape.size.x)
	bottle.position.y = round(randf() * area.shape.size.y)
	bottle.rotation = randf() * 360
	self.add_child(bottle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	spawn_bottle()

