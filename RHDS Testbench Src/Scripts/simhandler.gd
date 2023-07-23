extends Node

var waitforload = true

func _process(_delta):
	if waitforload == true:
		await get_tree().create_timer(2).timeout
		waitforload = false
	SimVars.computeValve(SimVars.MainValve, SimVars.Reservoir1, SimVars.Reservoir2)
	SimVars.computeValve(SimVars.SecondValve, SimVars.Reservoir2, SimVars.Reservoir3)
