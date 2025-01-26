extends Node2D

@onready var speech_bubble: SpeechBubble = $"SpeechBubble"
@export var id: String
@export var picture: Texture

@onready var audio_player = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.send_speak.connect(_on_send_speak)
	if (picture):
		$Sprite2D.texture = picture;

func _on_send_speak(_id, _act):
	audio_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	SignalManager.send_speak.emit(id, SignalManager.speak_actions.ENTER_SHOP)
