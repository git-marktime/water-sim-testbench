extends Sprite2D

func _process(_delta):
	var displayvalue = SimVars.PowerDemand
	var decimaltruncate = 0.1
	
	$Value.text = str(snapped(displayvalue, decimaltruncate))
	
	if SimVars.DemandMet == true:
		$NumberDisplay2/Value2.add_theme_color_override("default_color", Color(0.0, 0.56, 0.0))
	else:
		$NumberDisplay2/Value2.add_theme_color_override("default_color", Color(0.18, 0.18, 0.18))
