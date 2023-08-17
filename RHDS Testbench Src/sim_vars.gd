extends Node

class Reservoir:
	var Length
	var Width
	var Height
	var Volume
	var MaxVolume

var powerflipped = false

func initReservoir(L: float, W: float, H: float, V: float):
	var tempres = Reservoir.new()
	tempres.Length = L
	tempres.Width = W
	tempres.Height = H
	tempres.Volume = L * W * H
	tempres.MaxVolume = V
	
	return tempres

func updateReservoirVolume(reservoir: Reservoir):
	reservoir.Volume = reservoir.Length * reservoir.Width * reservoir.Height

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

class Gate:
	var VolumetricFlowRate = 0.0
	var MassFlowRate = 0.0
	var ValvePercent = 0.0
	var Opening
	var Width
	var MaxOpening
	var PullReservoir
	var PushReservoir
	var Blocked = false

func initGate(W: float, MAX: float, PULL: Reservoir, PUSH: Reservoir):
	var tempgate = Gate.new()
	tempgate.VolumetricFlowRate = 0.0
	tempgate.MassFlowRate = 0.0
	tempgate.ValvePercent = 0.0
	tempgate.Opening = 0.0
	tempgate.MaxOpening = MAX
	tempgate.Width = W
	tempgate.PullReservoir = PULL
	tempgate.PushReservoir = PUSH
	tempgate.Blocked = false
	
	return tempgate

func updateGate(gate: Gate):
	gate.Opening = (0 + (gate.MaxOpening - 0) * gate.ValvePercent) * gate.Width
	gate.VolumetricFlowRate = pow(gate.Opening * 9.81 * (gate.PullReservoir.Height - gate.PushReservoir.Height)/2.0 * 0.5, 
	0.5) 
	gate.MassFlowRate = gate.VolumetricFlowRate * 1027

func handleReservoirGateSubtractive(gate: Gate, reservoir: Reservoir):
	if reservoir.Volume > 0:
		gate.Blocked = false
		reservoir.Volume -= gate.VolumetricFlowRate/Performance.get_monitor(Performance.TIME_FPS)
		updateReservoirHeight(reservoir)
	else:
		gate.Blocked = true

func handleReservoirGateAdditive(gate: Gate, reservoir: Reservoir):
	if reservoir.Volume < reservoir.MaxVolume:
		gate.Blocked = false
		reservoir.Volume += gate.VolumetricFlowRate/Performance.get_monitor(Performance.TIME_FPS)
		updateReservoirHeight(reservoir)
	else:
		gate.Blocked = true

func handleGate(gate: Gate, valvePercent: float):
	if gate.Blocked == false:
		gate.ValvePercent = valvePercent
		updateGate(gate)
	else:
		gate.ValvePercent = 0
		updateGate(gate)

func computeGate(gate: Gate):
	if gate.Blocked == true:
		handleGate(gate, 0)

	if gate.PullReservoir.Volume > 0 and gate.PushReservoir.Volume < gate.PushReservoir.MaxVolume:
		gate.Blocked = false
		handleReservoirGateSubtractive(gate, gate.PullReservoir)
		handleReservoirGateAdditive(gate, gate.PushReservoir)
	else:
		gate.Blocked = true
		
func computePowerOutput():
	var turbine_power_coefficient = 0
	if TurbineHall.Volume >= 100 and TurbineHall.Volume <= 750:
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

func reduceWaterLevel(reservoir: Reservoir, flowrate: float):
	if reservoir.Volume > 0:
		reservoir.Volume -= flowrate/Performance.get_monitor(Performance.TIME_FPS)
		updateReservoirHeight(reservoir)

func getCurrentPowerDemand():
	var time = Time.get_time_dict_from_system(true)
	
	# Hour : Demand
	var demand_data_dictionary = {
		0 : randi_range(20, 40), # 24:00 / 00:00
		1 : randi_range(30, 50), # 01:00
		2 : randi_range(70, 100), # 02:00
		3 : randi_range(100, 150), # 03:00
		4 : randi_range(150, 190), # 04:00
		5 : randi_range(230, 260), # 05:00
		6 : randi_range(360, 410), # 06:00
		7 : randi_range(400, 500), # 07:00
		8 : randi_range(400, 500), # 08:00
		9 : randi_range(400, 500), # 09:00
		10 : randi_range(400, 500), # 10:00
		11 : randi_range(400, 500), # 11:00
		12 : randi_range(420, 550), # 12:00
		13 : randi_range(420, 550), # 13:00
		14 : randi_range(420, 550), # 14:00
		15 : randi_range(420, 550), # 15:00
		16 : randi_range(420, 550), # 16:00
		17 : randi_range(420, 550), # 17:00
		18 : randi_range(450, 600), # 18:00
		19 : randi_range(420, 550), # 19:00
		20 : randi_range(350, 400), # 20:00
		21 : randi_range(250, 300), # 21:00
		22 : randi_range(70, 160), # 22:00
		23 : randi_range(40, 700) # 23:00
	}
	
	return demand_data_dictionary.get(time.hour)

func doPowerDemandTick():
	var time = Time.get_time_dict_from_system(true)
	TimeLeftInPeriod = 60 - time.minute
	if TimeLeftInPeriod == 60:
		if powerflipped == false:
			powerflipped = true
			PowerDemand = getCurrentPowerDemand()
	else:
		powerflipped = false

var UpperReservoir = initReservoir(840, 1462, 90, 122_808_000)
var Penstock = initReservoir(100, 2, 0, 100)
var TurbineInlet = initValve(5, 0.5)
var TurbineHall = initReservoir(5, 20, 0, 1000)
var turbineOutlet = initValve(5.5, 0.6)
var DraftTube = initReservoir(10, 1.5, 0, 45)
var DraftTubeOutlet = initValve(4.5, 0.5)
var LowerReservoir = initReservoir(1_530, 10, 40, 764_805)
var PumpBackValve = initValve(2, 0.5)

var WATERDUMP = initReservoir(100, 10, 0, 1.79769e308)
var ReservePump = initValve(6, 1)
var EmergencyReserves = initReservoir(1.79769e308, 1.79769e308, 1.79769e308, 1.79769e308)

var SluiceGate = initGate(5, 3, UpperReservoir, Penstock)
var Spillway = initGate(5, 5, LowerReservoir, WATERDUMP)

var PowerOutput = 0
var PowerDemand = getCurrentPowerDemand()
var TimeLeftInPeriod = 81
var TurbineEfficiency = 0
var DemandMet = false
