extends Panel

@onready var item_visuals= $item_display

func update(item: InvItem):
	if !item:
		item_visuals = false
	else:
		item_visuals = true
		item_visuals.texture = item.texture
