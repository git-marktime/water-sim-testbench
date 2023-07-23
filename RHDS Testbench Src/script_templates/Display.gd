# meta-name: Display Template
# meta-description: Standard handling of a display

extends _BASE_

var displayvalue = KEY_NONE
var decimaltruncate = 0.01

func _process(_delta):
	$Value.text = str(snapped(displayvalue, decimaltruncate))
