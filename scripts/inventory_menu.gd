extends BoxContainer
@onready var player = get_node("../../Player")
@onready var inventory_item = preload("res://scenes/gui/inventory_item.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	player.inventory.item_changed.connect(_on_item_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_changed(item: Item):
	set_inventory(player.inventory.inventory)

func set_inventory(itemStacks):
	var element = $ItemContainer
	for n in element.get_children():
		element.remove_child(n)
		n.queue_free() 
	
	var id = 0
	for itemStack in itemStacks:
		var itemSprite= itemStack.item.ui_icon
		var texture = ImageTexture.create_from_image(itemSprite)
		var itemEntity = inventory_item.instantiate()
		itemEntity.get_node("TextureRect").set_texture(texture)
		itemEntity.get_node("QuantityText").set_text(str(itemStack.quantity))
		element.add_child(itemEntity)
		id += 1
	print(element.get_children())
		
