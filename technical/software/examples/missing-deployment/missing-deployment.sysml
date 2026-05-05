package MissingDeploymentExample {
    import DistributedSystems::*;

    // Intentionally incomplete: service has no modeled deployment allocation.
    part orphanService : Service {
        attribute serviceName = "orphan-service";
    }
}
