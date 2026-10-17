package MotorController {
    doc /*
     * Embedded motor-control firmware built from Elan8::Software: periodic and
     * event-driven tasks with their timing, a bounded queue, an execution
     * platform allocated to a microcontroller, and a firmware generation view.
     */
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import Elan8::Units::Engineering::*;
    private import Elan8::Software::*;
    private import Elan8::Electronics::Compute::*;
    private import Elan8::Generation::*;

    item def SpeedSetpoint { attribute speed : AngularVelocityValue; }
    item def FaultEvent { attribute code : Natural; }

    #query action def MeasuredSpeed { out speed : AngularVelocityValue; }
    #command action def ApplySetpoint { in setpoint : SpeedSetpoint; }
    #command action def EnterSafeState;

    #task part def SpeedControlLoop :> PeriodicTask {
        attribute :>> period = 1 [ms];
        attribute :>> deadline = 1 [ms];
        attribute :>> worstCaseExecutionTime = 0.2 [ms];
        attribute :>> priority = 3;
        attribute :>> criticality = TaskCriticality::safetyCritical;
        action measure : MeasuredSpeed;
        #idempotent action apply : ApplySetpoint;
    }

    #task part def FaultHandler :> EventDrivenTask {
        attribute :>> minimumInterArrivalTime = 10 [ms];
        attribute :>> deadline = 2 [ms];
        attribute :>> worstCaseExecutionTime = 0.1 [ms];
        attribute :>> priority = 4;
        attribute :>> criticality = TaskCriticality::safetyCritical;
        action safeState : EnterSafeState;

        state faultHandling {
            entry; then monitoring;
            state monitoring;
            accept FaultEvent then safe;
            state safe;
        }
    }

    part def SetpointQueue :> SoftwareQueue {
        attribute :>> discipline = QueueDiscipline::overwriteLatest;
        attribute :>> capacity = 1;
    }

    part controller {
        part mcu : Microcontroller {
            attribute :>> clockFrequency = 48000000 [Hz];
        }
        #platform part rtos : ExecutionPlatform {
            attribute :>> schedulingPolicy = SchedulingPolicy::fixedPriorityPreemptive;
            attribute :>> tickPeriod = 1 [ms];
        }
        part speedLoop : SpeedControlLoop;
        part faultHandler : FaultHandler;
        part setpoints : SetpointQueue;

        allocate rtos to mcu;
        allocate speedLoop to rtos;
        allocate faultHandler to rtos;
    }

    view firmwareCode : CodeGenerationView {
        @CodeGeneration { targetLanguage = ProgrammingLanguage::c; stateMachineStyle = StateMachineStyle::stateTable; }
        expose controller::**;
    }
}
