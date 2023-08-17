extends Node

var waitforload = true

func _process(_delta):
	if waitforload == true:
		await get_tree().create_timer(2).timeout
		waitforload = false
	
	SimVars.computeGate(SimVars.SluiceGate)
	SimVars.computeValve(SimVars.TurbineInlet, SimVars.Penstock, SimVars.TurbineHall)
	SimVars.computeValve(SimVars.turbineOutlet, SimVars.TurbineHall, SimVars.DraftTube)
	SimVars.computeValve(SimVars.DraftTubeOutlet, SimVars.DraftTube, SimVars.LowerReservoir)
	SimVars.computeValve(SimVars.PumpBackValve, SimVars.LowerReservoir, SimVars.UpperReservoir)
	SimVars.computeGate(SimVars.Spillway)
	SimVars.computeValve(SimVars.ReservePump, SimVars.EmergencyReserves, SimVars.UpperReservoir)
	SimVars.reduceWaterLevel(SimVars.WATERDUMP, 1.0)
	
	SimVars.doPowerDemandTick()
