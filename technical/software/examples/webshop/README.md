# Webshop Software Example

This example is the software-commerce scenario in `technical/software/examples/webshop/`. It combines a readable webshop model with reusable software-domain libraries from this repository.

Use this example if you want to see `spec42` applied to software architecture rather than a physical system.

## Try It With Spec42

From the repository root:

```bash
spec42 check technical/software/examples/webshop/webshop.sysml
```

In VS Code, open `webshop.sysml` and `Views.sysml` to explore the structure, interaction scenarios, action flow, state transition, and requirements views.

The entry model is `webshop.sysml`, which assembles:

- software structure built on shared libraries (`SoftwareCore`, `DistributedSystems`, `SqlDomain`, and `KubernetesDomain`)
- behavioral modeling (`OrderLifecycleStateMachine` and `CheckoutPipeline`)
- requirements with traceability (`requirement`, `satisfy`, and one illustrative `allocate`)
- interaction scenarios for synchronous checkout orchestration and asynchronous event fan-out

The corresponding views in `Views.sysml` are:

- `structure` (`GeneralView`)
- `connections` (`InterconnectionView`)
- `checkoutFlow` (`SequenceView`)
- `orderEventFanout` (`SequenceView`)
- `orderLifecycle` (`StateTransitionView`)
- `checkoutPipeline` (`ActionFlowView`)
- `requirements` (`GeneralView`)

This model intentionally omits the full e-commerce-platform operational depth (BFF/mobile edge split, gRPC pricing service, retry/DLQ topic set, and broader platform observability/delivery surface) to stay compact and easy to learn.
