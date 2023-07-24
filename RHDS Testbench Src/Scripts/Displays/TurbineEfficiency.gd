extends Sprite2D

func _process(_delta):
	var displayvalue = SimVars.TurbineEfficiency
	var decimaltruncate = 0.01
	
	$Value.text = str(snapped(displayvalue*100, decimaltruncate))
