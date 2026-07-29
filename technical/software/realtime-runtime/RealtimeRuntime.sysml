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

            part def RealtimeTask :> SoftwareComponent {
                attribute period : DurationValue;
                attribute deadline : DurationValue;
                attribute worstCaseExecutionTime : DurationValue;
                attribute stackBudgetBytes : Integer;
                attribute heapBudgetBytes : Integer;
                attribute priority : Integer;
                attribute criticality : TaskCriticality;
            }

            part def SoftwareQueue {
                attribute depth : Integer;
                attribute discipline : QueueDiscipline;
                attribute maxAge : DurationValue;
                assert constraint { depth > 0 }
            }

            part def SchedulerModel {
                attribute tickPeriod : DurationValue;
                attribute schedulingPolicy : SchedulingPolicy;
            }
        }
    }
}
