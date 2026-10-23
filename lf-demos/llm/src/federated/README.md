# LLM Demo (Federated Execution) Overview
This is a quiz-style game between two LLM agents using federated execution. For each user question asked to the Judge, both agents answer in parallel. The Judge announces whichever answer arrives first (or a timeout if neither responds within 5 sec), and prints per-question elapsed physical times. There are three federates (federate__llma, federate__llmb, federate__j) and an RTI.
# Pre-requisites 
For prerequisites and installation instructions, please refer to the [main README for this demo](../../README.md).
# Files in this directory
  - **`llm_base_class_federate.lf`** - Contains the base reactors LlmA, LlmB and Judge.
  - **`llm_game_federated.lf`** - Lingua Franca program that defines the quiz game as federated execution.
# Execution Workflow 
### Step 1: 
To compile this specify the RTI host by specifying an IP address here:
```
federated reactor llm_game_federated at localhost {
}
```
Run the **`llm_game_federated.lf`**.  \
**Note:**  Ensure that you specify the correct file paths. \
Run the following commands:  
```
lfc src/federated_execution/llm_game_federated.lf
```
### Step 2: Run the binary file and input the quiz question
Run the following command:  
```
cd fed-gen/llm_game_federated/
```
In the first terminal run:
```
./bin/RTI -n 3
```
In the second terminal run:
```
./bin/federate__j
```
In the third terminal run:
```
./bin/federate__llma
```
In the fourth terminal run:
```
./bin/federate__llmb
```
The system will ask for entering the quiz question which is to be obtained from the keyboard input. \
Example output printed on the terminal where federate__j is running:
<pre>
--------------------------------------------------
******* Using Python version: 3.12.3
---- System clock resolution: 1 nsec
---- Start execution on Mon Dec 22 15:55:00 2025 ---- plus 93997387 nanoseconds
Fed 0 (j_main): Connected to localhost:15045.
Fed 0 (j_main): Starting timestamp is: 1766444115021857259.
[Judge] Waiting for models
[Judge] Ready
Enter the quiz question (or 'quit')
what is the opposite of tall?

Query: what is the opposite of tall?

waiting...

LLM-A inference time: 848 ms | LLM-B inference time: 1128 ms
Winner: LLM-A | Chosen inference time 848 ms | Judge physical time 1175 ms
A: The opposite of tall is short.
--------------------------------------------------
</pre>
# Contributors
- Deeksha Prahlad (dprahlad@asu.edu), Ph.D. student at Arizona State University
- Hokeun Kim (hokeun@asu.edu, https://hokeun.github.io/), Assistant professor at Arizona State University 
