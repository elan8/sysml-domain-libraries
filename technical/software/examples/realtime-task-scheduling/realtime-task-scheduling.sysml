/*
 * Minimal composition proving RealtimeRuntime (technical/software) and
 * PartProcurement (generic) reuse the same pattern the sysml-robot-vacuum-cleaner
 * showcase uses locally, without any product-specific vocabulary.
 */
package RealtimeTaskSchedulingExample {
    private import RealtimeRuntime::*;
    private import PartProcurement::*;
    private import SoftwareCore::*;
    private import ISQ::*;
    private import SI::*;

    part def SampleComputeModule :> SoftwareComponent {
        @BuyPart {
            manufacturer = "Example Semiconductor Co.";
            manufacturerPartNumber = "ES-MCU-100";
            productPageUrl = "https://example.invalid/es-mcu-100";
            datasheetUrl = "https://example.invalid/es-mcu-100/datasheet";
            datasheetDocumentId = "DS-0001";
            datasheetRevision = "Rev 1";
            lifecycleStatus = PartLifecycleStatus::active;
            sourceCheckedOn = "2026-07-28";
        }
    }

    part def SensorTask :> RealtimeTask {
        attribute :>> period = 20 [ms];
        attribute :>> deadline = 20 [ms];
        attribute :>> worstCaseExecutionTime = 3 [ms];
        attribute :>> stackBudgetBytes = 4096;
        attribute :>> heapBudgetBytes = 1024;
        attribute :>> priority = 6;
        attribute :>> criticality = TaskCriticality::safetyCritical;
        action run {
            out item reading : Real;
        }
    }

    part def ControlTask :> RealtimeTask {
        attribute :>> period = 50 [ms];
        attribute :>> deadline = 50 [ms];
        attribute :>> worstCaseExecutionTime = 4 [ms];
        attribute :>> stackBudgetBytes = 4096;
        attribute :>> heapBudgetBytes = 4096;
        attribute :>> priority = 5;
        attribute :>> criticality = TaskCriticality::missionCritical;
        action run {
            in item reading : Real;
        }
    }

    part def SensorReadingQueue :> SoftwareQueue {
        attribute :>> depth = 4;
        attribute :>> discipline = QueueDiscipline::overwriteLatest;
        attribute :>> maxAge = 100 [ms];
        action transfer {
            in item enqueue : Real;
            out item dequeue : Real;
        }
    }

    part sampleSystem {
        part compute : SampleComputeModule;
        part scheduler : SchedulerModel {
            attribute :>> tickPeriod = 1 [ms];
            attribute :>> schedulingPolicy = SchedulingPolicy::fixedPriorityCooperative;
        }
        part sensorTask : SensorTask;
        part controlTask : ControlTask;
        part readingQueue : SensorReadingQueue;

        flow sensorTask.run.reading to readingQueue.transfer.enqueue;
        flow readingQueue.transfer.dequeue to controlTask.run.reading;
    }
}
