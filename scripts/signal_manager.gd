extends Node

signal send_speak
signal receive_speak
signal send_help_text

enum speak_actions {ENTER_SHOP, YEAST, SUGAR, BUCKET, NO_MONEY}

var sugar_phrases = ['Baking something?', 'Oh you so sweet', 'That\'s a lot of sugar', 'Are you buing something else?']
var yeast_phrases = ['Making beer?', 'Holy moly that\'s cheap', 'Buy two and you get two for free', 'Are you buing something else?']
var bucket_phrases = ['Niceee', 'Home wining session coming?', 'They be buying my bukkit']
var enter_shop_phrases = ['What?','Welcome!', 'What can I get you?', 'YO!', 'We have sale on yeast' ]
var no_money_phares = ['You need money u know', 'No money, no honey', 'uuhmmm... you don\'t have money?']


func _ready() -> void:
	send_speak.connect(_on_send_speak)

func _on_send_speak(id, action: speak_actions):
	match action:
		speak_actions.ENTER_SHOP:
			receive_speak.emit(id, enter_shop_phrases.pick_random())
		speak_actions.YEAST:
			receive_speak.emit(id, yeast_phrases.pick_random())
		speak_actions.SUGAR:
			receive_speak.emit(id, sugar_phrases.pick_random())
		speak_actions.BUCKET:
			receive_speak.emit(id, bucket_phrases.pick_random())
		speak_actions.NO_MONEY:
			receive_speak.emit(id, no_money_phares.pick_random())
