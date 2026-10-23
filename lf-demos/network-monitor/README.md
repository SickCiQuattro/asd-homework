# Network latency monitoring

These examples show how to use LF to monitor the network underlying a federation.

## Prerequisits
- Java 17
- libwebsockets
- libmicrohttpd `apt install libmicrohttpd` or `brew install libmicrohttpd`

## Examples
### [Probe4.lf](src/Probe4.lf)
This example introduces several library reactors for monitoring network latencies within a federation. 
The federation is instantiated as a bank with all-to-all connections and each federate measures the network
latency to all other federates. The measurements are filtered with a moving worst case filter and exposed
by a HTTP server. This program could run in the background, as a daemon and let other programs on the host 
utilize the latency measurements.

To run

```sh
lfc src/Probe4.lf
bin/Probe4
```

To inspect the latency measurements performed by federate 0, open [HttpPlotClient.html](src/lib/HttpPlotClient.html) in a browser

### [Probe5.lf](src/Probe5.lf)
This example builds on Probe4, and shows how we can leverage the latencies measurements
within the very same LF program. Federate 0 sends out a shell command to all other federates together with a timestamp
for when to invoke it, which is the maximum of all filtered latencies.

To run

```sh
lfc src/Probe5.lf
bin/Probe5
```

Latency measurements can again be inspected with [HttpPlotClient.html](src/lib/HttpPlotClient.html)

## More Primitive Examples

* [Probe1.lf](src/Probe1.lf): Two probes on the local machine reporting to a web socket. View by opening [http://localhost:8080](http://localhost:8080) and [http://localhost:8081](http://localhost:8081).

* [Probe3.lf](src/Probe3.lf): An attempt to put two of the probes on a remote machine. This may be difficult to run.


