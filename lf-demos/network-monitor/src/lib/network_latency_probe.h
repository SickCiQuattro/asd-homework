#ifndef NETWORK_LATENCY_PROBE_H
#define NETWORK_LATENCY_PROBE_H

typedef enum {
  LATENCY_INVALID, LATENCY_REQUEST, LATENCY_RESPONSE
} LatencyMessageType;

typedef struct {
  LatencyMessageType type;
  int sequence_number;
  interval_t timestamp;
} LatencyMessage;



#endif