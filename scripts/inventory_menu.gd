extends BoxContainer
@onready var player = get_node("../../Player")
@onready var inventory_item = preload("res://scenes/gui/inventory_item.tscn")
@onready var item_container = $ItemContainer

var _selected_index = -1
var _enabled: bool = false

signal item_used(id: Item.Id)

# Called when the node enters the scene tree for the first time.
func _ready():
	player.inventory.item_changed.connect(_on_item_changed)
	
func enable(value: bool):
	_enabled = value
	if _enabled:
		_selected_index = 0
		_highlight_selected()
	else:
		_deselect_all_items()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not _enabled:
		return
		
	if len(item_container.get_children()) == 0:
		return
		
	var _prev_index = _selected_index
	if Input.is_action_just_pressed("move_right"):
		_selected_index = posmod((_selected_index + 1), len(item_container.get_children()))
	if Input.is_action_just_pressed("move_left"):
		_selected_index = posmod((_selected_index - 1), len(item_container.get_children()))
		
	_deselect_all_items()
	_highlight_selected()
	if Input.is_action_just_pressed("player_action"):
		var item = item_container.get_child(_selected_index).item
		if item.id == Item.Id.YEAST or item.id == Item.Id.SUGAR:
			var item_count = player.inventory.get_item_amount(item)
			if item_count > 0:
				player.inventory.remove_item(item, 1)
				item_used.emit(item.id)
		#else:
			# teksti ruudulle: why would you do that??

func _highlight_selected():
	if _selected_index >= len(item_container.get_children()):
		return
	item_container.get_child(_selected_index).set_active(true)
	var new_selection = item_container.get_child(_selected_index)
	new_selection.set_active(true)

func _deselect_all_items():
	for item in item_container.get_children():
		item.set_active(false)

func _on_item_changed(item: Item):
	set_inventory(player.inventory.inventory)

func set_inventory(itemStacks):
	for n in item_container.get_children():
		item_container.remove_child(n)
		n.queue_free() 
	
	for itemStack in itemStacks:
		var itemSprite= itemStack.item.ui_icon
		var itemEntity = inventory_item.instantiate()
		itemEntity.get_node("TextureRect").set_texture(itemStack.item.ui_icon)
		itemEntity.get_node("QuantityText").set_text(str(itemStack.quantity))
		itemEntity.item = itemStack.item
		if itemStack.quantity > 0:
			item_container.add_child(itemEntity)
		


func _on_bucket_fill_view_closed() -> void:
	_deselect_all_items()
	_selected_index = -1
