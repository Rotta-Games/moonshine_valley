extends Control


@onready var _container: BoxContainer = $"BoxContainer"
@onready var _start_button: Button = $"BoxContainer/Start"
@onready var _instructions_button: Button = $"BoxContainer/Instructions"
@onready var _instructions_text: RichTextLabel = $"InstructionText"


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


func _on_instructions_pressed() -> void:
	_instructions_text.visible = true
	_container.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("player_cancel"):
		if _instructions_text.visible:
			_instructions_text.visible = false
			_container.visible = true
			_instructions_button.grab_focus()
