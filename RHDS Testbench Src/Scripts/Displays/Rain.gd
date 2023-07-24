extends Sprite2D

func _process(_delta):
	var displayvalue = SimVars.Rain.VolumetricFlowRate
	var decimaltruncate = 0.01
	
	$Value.text = str(snapped((displayvalue/3.14*pow(SimVars.Rain.Diameter/2, 2))*1000000, decimaltruncate))
