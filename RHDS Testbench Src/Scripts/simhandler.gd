extends Node

var waitforload = true

func _process(_delta):
	if waitforload == true:
		await get_tree().create_timer(2).timeout
		waitforload = false
	
	SimVars.computeValve(SimVars.SluiceGate, SimVars.UpperReservoir, SimVars.Penstock)
	SimVars.computeValve(SimVars.TurbineInlet, SimVars.Penstock, SimVars.TurbineHall)
	SimVars.computeValve(SimVars.turbineOutlet, SimVars.TurbineHall, SimVars.DraftTube)
	SimVars.computeValve(SimVars.DraftTubeOutlet, SimVars.DraftTube, SimVars.LowerReservoir)
	SimVars.computeValve(SimVars.PumpBackValve, SimVars.LowerReservoir, SimVars.UpperReservoir)
	SimVars.computeValve(SimVars.Spillway, SimVars.LowerReservoir, SimVars.WATERDUMP)
	SimVars.computeValve(SimVars.ReservePump, SimVars.EmergencyReserves, SimVars.UpperReservoir)
	
	SimVars.computePowerOutput()
