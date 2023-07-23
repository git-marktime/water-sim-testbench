extends HSlider

func _process(_delta):
	var new_value = value
	$Value.text = str(new_value)
	SimVars.handleValve(SimVars.SecondValve, new_value/100)
