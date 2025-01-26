extends Control
@onready var player = get_node("../../Player")


var active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	player.pause_button_pressed.connect(_on_pause_button_pressed)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_pause_button_pressed():
	$BoxContainer/ResumeButton.grab_focus()
	
	if active == true:
		_hide()
	else:
		_show()

func _on_resume_button_pressed():
	_hide()

func _on_help_button_pressed():
	pass # Replace with function body.

func _show():
	get_tree().paused = true
	set_process_input(true)
	active = true
	self.show()

func _hide():
	get_tree().paused = false
	set_process_input(false)
	active = false
	self.hide()
	

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _input(event):
	var current = get_viewport().gui_get_focus_owner()
	if not current: 
		return

	if event.is_action_pressed("player_action"):
		if current is Button:
			current.emit_signal("pressed")
