extends PopupDialog


func _ready():
	pass # Replace with function body.

func _on_ClosePopup_pressed():
	self.set_visible(false)
	get_parent().disable_buttons(false)
