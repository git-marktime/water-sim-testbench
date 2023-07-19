package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"
	"time"

	"atomicgo.dev/cursor"
)

func lerp(start float32, end float32, inter float32) float32 {
	return start + (end-start)*inter
}

func clamp(x float32, lower float32, upper float32) float32 {
	if x > upper {
		return upper
	}
	if x < lower {
		return lower
	}
	return x
}

type Valve struct {
	MassFlowRate       float32
	VolumetricFlowRate float32
	Velocity           float32
	OpenPercent        float32
	MaxVelocity        float32
	PipeDiameter       float32
}

type Reservoir struct {
	Volume float32
	Length float32
	Width  float32
	Height float32
}

func newReservoir(length float32, width float32, height float32) Reservoir {
	return Reservoir{
		Volume: length * width * height,
		Length: length,
		Width:  width,
		Height: height,
	}
}

func newValve(diameter float32, maxvelocity float32) Valve {
	return Valve{
		MassFlowRate:       0.0,
		VolumetricFlowRate: 0.0,
		Velocity:           0.0,
		OpenPercent:        0.0,
		MaxVelocity:        maxvelocity,
		PipeDiameter:       diameter,
	}
}

func updateValve(valve Valve) Valve {
	valve.Velocity = lerp(0, valve.MaxVelocity, valve.OpenPercent)

	area := 3.14 * math.Pow((float64(valve.PipeDiameter)/2), 2.0)
	valve.VolumetricFlowRate = valve.Velocity * float32(area)
	valve.MassFlowRate = valve.VolumetricFlowRate * 998

	return valve
}

func updateReservoir(reservoir Reservoir) Reservoir {
	reservoir.Volume = clamp(reservoir.Volume, 0.0, math.MaxFloat32)
	reservoir.Height = reservoir.Volume / (reservoir.Length * reservoir.Width)

	return reservoir
}

func handleWater1(water Reservoir, intervalve Valve) Reservoir {
	water.Volume -= intervalve.VolumetricFlowRate
	return water
}

func handleWater2(water Reservoir, intervalve Valve) Reservoir {
	water.Volume += intervalve.VolumetricFlowRate
	return water
}

func main() {
	var water1 = newReservoir(100, 100, 50)
	var water2 = newReservoir(200, 200, 100)
	var intervalve = newValve(0.5, 2)

	var temp string
	fmt.Print("Input valve percentage (0.0 => 1.0): ")
	fmt.Scan(&temp)
	temp = strings.TrimSpace(temp)
	value, _err := strconv.ParseFloat(temp, 32)

	if _err != nil {
		println("error")
	}

	println("")

	value = float64(clamp(float32(value), 0.0, 1.0))

	intervalve.OpenPercent = float32(value)

	cursor.Hide()

	// game loop
	for {
		time.Sleep(500000000) // 500 milisecond refresh rate

		water1 = handleWater1(water1, intervalve)
		water2 = handleWater2(water2, intervalve)

		water1 = updateReservoir(water1)
		water2 = updateReservoir(water2)
		intervalve = updateValve(intervalve)

		println("water 1: " + strconv.FormatFloat(float64(water1.Volume), 'f', -1, 32) + " cubic meters")
		println("water 1: " + strconv.FormatFloat(float64(water1.Height), 'f', -1, 32) + " meters\n")

		println("water 2: " + strconv.FormatFloat(float64(water2.Volume), 'f', -1, 32) + " cubic meters")
		println("water 2: " + strconv.FormatFloat(float64(water2.Height), 'f', -1, 32) + " meters\n")

		println("valve: " + strconv.FormatFloat(float64(intervalve.VolumetricFlowRate), 'f', -1, 32) + "cubic m/s")
		println("valve: " + strconv.FormatFloat(float64(intervalve.Velocity), 'f', -1, 32) + "m/s\n")

		cursor.Up(9)
	}
}
