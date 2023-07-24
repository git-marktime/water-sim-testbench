extends Node

class Reservoir:
	var Length
	var Width
	var Height
	var Volume
	var MaxVolume

func initReservoir(L: float, W: float, H: float, V: float):
	var tempres = Reservoir.new()
	tempres.Length = L
	tempres.Width = W
	tempres.Height = H
	tempres.Volume = L * W * H
	tempres.MaxVolume = V
	
	return tempres

func updateReservoirVolume(reservoir: Reservoir):
	reservoir.Volume = reservoir.Length + reservoir.Width + reservoir.Height

func updateReservoirHeight(reservoir: Reservoir):
	reservoir.Height = reservoir.Volume / (reservoir.Length * reservoir.Width)

class Valve:
	var VolumetricFlowRate = 0.0
	var MassFlowRate = 0.0
	var ValvePercent = 0.0
	var Velocity = 0.0
	var MaxVelocity
	var Diameter
	var Blocked = false

func initValve(V: float, D: float):
	var tempvalve = Valve.new()
	tempvalve.VolumetricFlowRate = 0.0
	tempvalve.MassFlowRate = 0.0
	tempvalve.ValvePercent = 0.0
	tempvalve.Velocity = 0.0
	tempvalve.MaxVelocity = V
	tempvalve.Diameter = D
	tempvalve.Blocked = false
	
	return tempvalve

func updateValve(valve: Valve):
	var radius = valve.Diameter/2.0
	var area = 3.14*pow(radius, 2)
	valve.Velocity = (0 + (valve.MaxVelocity - 0) * valve.ValvePercent)
	valve.VolumetricFlowRate = valve.Velocity * area
	valve.MassFlowRate = valve.VolumetricFlowRate * 997 # kg/m^3

func handleReservoirSubtractive(valve: Valve, reservoir: Reservoir):
	if reservoir.Volume > 0:
		valve.Blocked = false
		reservoir.Volume -= valve.VolumetricFlowRate/Performance.get_monitor(Performance.TIME_FPS)
		updateReservoirHeight(reservoir)
	else:
		valve.Blocked = true

func handleReservoirAdditive(valve: Valve, reservoir: Reservoir):
	if reservoir.Volume < reservoir.MaxVolume:
		valve.Blocked = false
		reservoir.Volume += valve.VolumetricFlowRate/Performance.get_monitor(Performance.TIME_FPS)
		updateReservoirHeight(reservoir)
	else:
		valve.Blocked = true

func handleValve(valve: Valve, valvePercent: float):
	if valve.Blocked == false:
		valve.ValvePercent = valvePercent
		updateValve(valve)
	else:
		valve.ValvePercent = 0
		updateValve(valve)

func computeValve(valve: Valve, pullReservoir: Reservoir, pushReservoir: Reservoir):
	if valve.Blocked == true:
		handleValve(valve, 0)

	if pullReservoir.Volume > 0 and pushReservoir.Volume < pushReservoir.MaxVolume:
		valve.Blocked = false
		handleReservoirSubtractive(valve, pullReservoir)
		handleReservoirAdditive(valve, pushReservoir)
	else:
		valve.Blocked = true

func computePowerOutput():
	var turbine_power_coefficient = 0
	if TurbineHall.Volume >= 100 and TurbineHall.Height <=750:
		turbine_power_coefficient = -0.0000085 * (TurbineHall.Volume-100) * (TurbineHall.Volume-750)
	else:
		turbine_power_coefficient = 0
	
	var turbine_radius = 1 # m
	
	var a = pow(TurbineInlet.Velocity, 2) # m/s ^2s
	var m = 1027 * 3.14 * pow(TurbineInlet.Diameter/2, 2) # kg
	var F = m * a # newtons
	
	var angle = 0
	if TurbineInlet.Velocity > 0:
		angle = turbine_radius/TurbineInlet.Velocity # angular velocity, rad/s
	else:
		angle = 0
	var disp = angle * turbine_radius # m
	var w = F * disp # joules
	var power = w * turbine_power_coefficient # joules / sec or watts
	PowerOutput = power
	TurbineEfficiency = turbine_power_coefficient
	
	if PowerOutput >= PowerDemand - 10 and PowerOutput <= PowerDemand + 10:
		DemandMet = true
	else:
		DemandMet = false

var UpperReservoir = initReservoir(840, 1462, 90, 122_808_000)
var SluiceGate = initValve(6, 2)
var Penstock = initReservoir(100, 2, 0, 100)
var TurbineInlet = initValve(5, 0.5)
var TurbineHall = initReservoir(5, 20, 0, 1000)
var turbineOutlet = initValve(5.5, 0.6)
var DraftTube = initReservoir(10, 1.5, 0, 45)
var DraftTubeOutlet = initValve(4.5, 0.5)
var LowerReservoir = initReservoir(1_530, 10, 40, 764_805)
var PumpBackValve = initValve(2, 0.5)

var Spillway = initValve(7.5, 1)
var WATERDUMP = initReservoir(0.1, 0.1, 0, 1.79769e308)
var ReservePump = initValve(6, 1)
var EmergencyReserves = initReservoir(1.79769e308, 1.79769e308, 1.79769e308, 1.79769e308)

var PowerOutput = 0
var PowerDemand = randi_range(100, 800)
var TurbineEfficiency = 0
var DemandMet = false
