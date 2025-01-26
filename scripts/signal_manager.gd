extends Node

signal send_speak
signal receive_speak
signal send_help_text

enum speak_actions {ENTER_SHOP, YEAST, SUGAR, BUCKET, NO_MONEY, BUYING_PRODUCT, TOO_MUCH_SUGAR, NOT_ENOUGH_SUGAR, TOO_MUCH_YEAST, NOT_ENOUGH_YEAST, PRODUCT_TOO_EARLY, PRODUCT_SPOILED, PRODUCT_PERFECT}

var sugar_phrases = ['Baking something?', 'Oh you so sweet', 'That\'s a lot of sugar', 'Are you buing something else?']
var yeast_phrases = ['Making beer?', 'Holy moly that\'s cheap', 'Buy two and you get two for free', 'Are you buing something else?']
var bucket_phrases = ['Niceee', 'Home wining session coming?', 'They be buying my bukkit', 'I used to fill buckets at shower']
var enter_shop_phrases = ['What?','Welcome!', 'What can I get you?', 'YO!', 'We have sale on yeast' ]
var no_money_phares = ['You need money u know', 'No money, no honey', 'uuhmmm... you don\'t have money?']
var buying_product_phrases = ['Empty handed?', 'Unless you got product, get out', 'Not sure if I like you', 'Got something to sell?', 'Waiting for a shipment', 'Water is free you know']

var too_much_sugar_phrases = ['Too much sugar', 'Dude, tastes like sugar', 'Something wrong with ingredients']
var not_enough_sugar_phrases = ['Did you forget to add sugar?', 'Sour special?', 'Where\'s my sugar??']
var too_much_yeast_phrases = ['Too much yeast', 'Mmm, yeast..']
var not_enough_yeast_phrases = ['Did you forget to add yeast?', 'I don\'t think you nailed ingredients']
var too_early_product_phrases = ['That was not ready yet', 'Your product was shipped too early', 'Patience buddy']
var spoiled_product_phrases = ['Already gone bad', 'Smells bad', 'Smells like failure to me']
var perfect_product_phrases = ['Wow, this is perfect', 'DELICIOUS', 'I need more of this', 'Holy moly!', 'Very good', 'Couldn\'t ask for more']

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
		speak_actions.BUYING_PRODUCT:
			receive_speak.emit(id, buying_product_phrases.pick_random())
		speak_actions.TOO_MUCH_SUGAR:
			receive_speak.emit(id, too_much_sugar_phrases.pick_random())
		speak_actions.NOT_ENOUGH_SUGAR:
			receive_speak.emit(id, not_enough_sugar_phrases.pick_random())
		speak_actions.TOO_MUCH_YEAST:
			receive_speak.emit(id, too_much_yeast_phrases.pick_random())
		speak_actions.NOT_ENOUGH_YEAST:
			receive_speak.emit(id, not_enough_yeast_phrases.pick_random())
		speak_actions.PRODUCT_TOO_EARLY:
			receive_speak.emit(id, too_early_product_phrases.pick_random())
		speak_actions.PRODUCT_SPOILED:
			receive_speak.emit(id, spoiled_product_phrases.pick_random())
		speak_actions.PRODUCT_PERFECT:
			receive_speak.emit(id, perfect_product_phrases.pick_random())
			
