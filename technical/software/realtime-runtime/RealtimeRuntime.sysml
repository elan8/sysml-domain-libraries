package Elan8 {
    package Software {
        package Realtime {
            private import Elan8::Software::Core::*;
            private import ISQ::*;
            private import ScalarValues::*;

            enum def TaskCriticality {
                nonCritical;
                missionCritical;
                safetyCritical;
            }

            enum def QueueDiscipline {
                fifoDropNewest;
                fifoDropOldest;
                overwriteLatest;
            }

            enum def SchedulingPolicy {
                fixedPriorityCooperative;
            }

            abstract part def RealtimeTask :> SoftwareComponent {
                attribute deadline : DurationValue;
                attribute priority : Integer;
                attribute criticality : TaskCriticality;
            }

            abstract part def PeriodicTask :> RealtimeTask {
                attribute period : DurationValue;
            }

            abstract part def EventDrivenTask :> RealtimeTask;

            part def SoftwareQueue {
                attribute discipline : QueueDiscipline;
            }

            part def SchedulerModel {
                attribute tickPeriod : DurationValue;
                attribute schedulingPolicy : SchedulingPolicy;
            }
        }
    }
}
