package RobotControl {
    import RoboticsCore::*;
    import RobotActuation::*;

    attribute def ControlType;
    attribute def FeedbackKind;

    part def ControlLoop {
        attribute name : Name;
        attribute controlType : ControlType;
        ref controller : Controller;
        ref command : ActuationCommand;
        ref feedback : FeedbackSignal;
        ref setpoint : Setpoint;
        ref targetActuator : Actuator;
    }

    part def Controller {
        attribute name : Name;
    }

    part def TrajectoryController :> Controller;

    part def MotionCommand :> ActuationCommand;

    part def Setpoint {
        attribute name : Name;
    }

    part def FeedbackSignal {
        attribute name : Name;
        attribute feedbackKind : FeedbackKind;
    }
}
