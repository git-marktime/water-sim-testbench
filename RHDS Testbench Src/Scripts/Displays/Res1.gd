extends Sprite2D

func _process(_delta):
	var targetchecker = SimVars.Reservoir1
	var displayvalue = targetchecker.Volume
	var decimaltruncate = 0.01
	
	if displayvalue < 0:
		$Value.text = str(snapped(0, decimaltruncate))
	elif displayvalue > targetchecker.MaxVolume:
		$Value.text = str(snapped(targetchecker.MaxVolume, decimaltruncate))
	else:
		$Value.text = str(snapped(displayvalue, decimaltruncate))
