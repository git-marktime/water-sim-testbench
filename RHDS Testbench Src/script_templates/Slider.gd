extends HSlider

func _process(_delta):
	var new_value = value
	var target_valve = SimVars.SluiceGate
	
	$Value.text = str(new_value)
	SimVars.handleValve(target_valve, new_value/100)
