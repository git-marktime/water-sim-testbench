extends Sprite2D

func _process(_delta):
	var displayvalue = SimVars.PowerOutput
	var decimaltruncate = 0.1
	
	$Value.text = str(snapped(displayvalue, decimaltruncate))
