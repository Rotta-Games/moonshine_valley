extends Control


@onready var _start_button: Button = $"BoxContainer/Start"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
	_start_button.grab_focus()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
