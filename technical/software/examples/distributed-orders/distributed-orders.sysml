package DistributedOrdersExample {
    import DistributedSystems::*;

    part ordersApi : Service {
        attribute serviceName = "orders-api";
    }

    part paymentsApi : Service {
        attribute serviceName = "payments-api";
    }

    part nodeA : DeploymentNode {
        attribute nodeName = "node-a";
        attribute host = "orders.example.internal";
    }

    part nodeB : DeploymentNode {
        attribute nodeName = "node-b";
        attribute host = "payments.example.internal";
    }
}
