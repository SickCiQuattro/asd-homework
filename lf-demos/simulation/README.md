# Integrating Lingua Franca with External Simulators

A common situation is that Lingua Franca program needs to interact with an external simulation engine such as Mujoco, Carla, Modelica, or some other simulator. LF is a timed language, and so are those simulators, making it desirable to coordinate the advancement of time in the two programs.

## Prerequisites

This demo depends on the [mujoco-c library](https://github.com/lf-lang/mujoco-c), which you can
install using [lingo](https://github.com/lf-lang/lingo) by running `lingo build` in this directory.

In addition, to get these demos to compile, you will need to install openSSL, Paho, and Mosquitto, as explained in the [mujoco-c library README file](https://github.com/lf-lang/mujoco-c/README.md).

## Patterns

There are (at least) four patterns that you could use.  Which to pick depends on the goals and the capabilities of the simulator.

1. **Asynchronous interaction**.  The simulator runs as fast as it does and sends data to LF when it does, and receives data from LF when LF sends it.  The LF program runs in real time (fast == false) and schedules physical actions whenever it receives data from the simulator.

2. **LF polls simulator**. The simulator runs as fast as it does and responds to queries for data from LF (either for sensor data or commands) whenever LF makes those queries.  The LF program runs in real time (fast == false) and uses timers to drive polling of the sensors and sending actuator commands to the simulator.

3. **Simulator locked to LF**.  LF runs in real time or fast and uses a timer to periodically issue "step" commands to the simulator, asking it to step its simulation by the specified amount of time. It issues actuator commands and polls for sensor data in between these step operations.

4. **LF locked to simulator**.  LF runs in fast mode and schedules a _logical_ action each time the simulator steps.  The simulator runs as fast as it does and drives the timing of the LF program.

## Advantages and Disadvantages

Each of these has advantages and disadvantages:

1. **Asynchronous interaction.**
  - Advantages: Simple and easy to implement.
  - Disadvantages: Simulations are not trustworthy because the model of time is not coordinated. There is little reason to believe an implementation would behave like the simulation.

2. **LF polls simulator.**
  - Advantages: If the simulator runs in real time, this gets closer to delivering a reasonable simulation with a coordinated model of time.
  - Disadvantages: Requires that the simulator have an API admitting asynchronous polling. If the simulator does not run in real time, however, the simulation results will not be trustworthy.  Even if the simulator does run in real time, there will be nondeterministic alignment problems.  Polling will align nondeterministically with the timing within the simulator.

3. **Simulator locked to LF.**
  - Advantages: Delivers rigorous, repeatable simulation semantics. Allows faster than real-time simulation.  Any simulator with an FMI interface can use this strategy.
  - Disadvantages: Requires that the simulator have a "step" API function that advances the simulation by a specified amount of time.

4. **LF locked to simulator.**
  - Advantages: Does not require that the simulator have a "step" API function.
  - Disadvantages: The LF program cannot contain any other actions or timers other than the logical action that is used to drive the timing of the LF program.  The program must be fully reactive to this stimulus. Requires that the simulator proactively supply sensor data and poll for actuator commands.  Also, this strategy cannot be used to interface to two simulators simultaneously.

## Goals

The overall goal is to have a hierarchical and disciplined approach to testing and validating LF programs.  Possible approaches include:

1. **Cloud-native development.** The LF program and external simulator run together with no real-time guarantees, but deliver accurate simulated timed behavior.
2. **Hardware-in-the-loop.** Here, the LF program may interact with external hardware _as well as_ an external simulator. This likely now imposes real-time requirements on both the LF program and the simulator.
3. **Deployment on target hardware.** Here, the LF program runs on its target embedded platform interacting with the simulator with real-time emulation of sensors and actuators.
4. **Digital shadow.** Here, the LF program and the simulator together track the behavior of a deployment on target hardware.

Ideally, we would have a methodology where the same LF program is run on all these levels. This is of course possible using something like ROS2 also, but we have a key advantage. We can guarantee that the program behavior will be identical for all levels, under clearly stated assumptions. The assumptions will be either:

1. Related to the simulation accuracy itself (moving from (2) -> (3) will only yield identical behavior of the simulator is correctly simulating the physics).
2. Related to execution-time and network-latencies of the LF program, which are stated in the program as deadlines
3. Related to the simulator real-time performance.

## Building

1. Install the [prerequisites for the MQTT library](https://github.com/lf-lang/mqtt-c?tab=readme-ov-file#prerequisites)
2. Intstall [Lingo](https://github.com/lf-lang/lingo)
3. Use Lingo to import the MQTT library:
```
  lingo build
```
4. Build all programs before running:
```
  lfc src/*.lf
```

## Experiments and Demos

In the following examples, at startup, each program launches an external program that stands in as a simulator that periodically sends messages via an MQTT publish-and-subcribe channel. The external program is implemented as another LF program, [FreeRunningSimulator](src/FreeRunningSimulator.lf). The simulator runs at its own speed (which happens to be real time).

- **[Asynchronous](src/Asychronous.lf)**: This example implements pattern 1 above. The timestamp of the incoming message is ignored and the message is assigned a timestamp based on the physical time at which the message is received. Launches [FreeRunningSimulator](src/FreeRunningSimulator.lf).
- **[PollSimulator](src/PollSimulator.lf)**: This example implements pattern 2 above. This launches [PolledSimulator](src/PolledSimulator.lf) after a 2 second delay (mosquitto doesn't seem to like simultaneous connection requests). It polls the simulator periodically, but each runs at its own rate.
- **[StepSimulator](src/StepSimulator.lf)**: This example implements pattern 3 above. This launches [SteppedSimulator](src/SteppedSimulator.lf) after a 1 second delay (mosquitto doesn't seem to like simultaneous connection requests). At 2s, it starts stepping the simulator periodically. A bit after 15s, it sends a stop message to the simulator.
- **[LockToSimulator](src/LockToSimulator.lf)**: This example implements pattern 4 above.  The LockToSimulator program runs in fast mode, as required by pattern 4, so its timing is determined by the [FreeRunningSimulator](src/FreeRunningSimulator.lf) program, which it launches at startup.



