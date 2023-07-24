extends HSlider

func _process(_delta):
	var new_value = value
	var target_valve = SimVars.SluiceGate
	var displayed_value = target_valve.VolumetricFlowRate
	
	$NumberDisplay/Value.text = str(new_value)
	SimVars.handleValve(target_valve, new_value/100)
	
	$NumberDisplay2/Value2.text = str(snapped(displayed_value, 0.001))
