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

var Reservoir1 = initReservoir(100, 100, 5, 75_000)
var Reservoir2 = initReservoir(100, 100, 0, 10)
var Reservoir3 = initReservoir(100, 100, 0, 75_000)
var MainValve = initValve(5, 0.5)
var SecondValve = initValve(5, 0.5)
