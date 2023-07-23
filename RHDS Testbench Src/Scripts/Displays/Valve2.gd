extends Sprite2D

func _process(_delta):
	var targetchecker = SimVars.SecondValve
	var displayvalue = targetchecker.VolumetricFlowRate
	var decimaltruncate = 0.001
	
	if displayvalue < 0:
		$Value.text = str(snapped(0, decimaltruncate))
	else:
		$Value.text = str(snapped(displayvalue, decimaltruncate))
