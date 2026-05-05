package ControlMissingFeedbackExample {
    import RobotControl::*;

    // Intentionally incomplete: no FeedbackSignal or Setpoint instance.
    part loop : ControlLoop {
        attribute name = "drive-loop";
        attribute controlType = "velocity";
    }

    part controller : TrajectoryController {
        attribute name = "main-controller";
    }
}
