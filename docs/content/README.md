# Atomix Cloud
<div style="text-align: justify"> 

Atomix Cloud is a [Kubernetes] native platform for building scalable, fault-tolerant distributed systems.
Developed at [ONF] as part of µONOS -- a next generation, cloud native software-defined network controller --
Atomix Cloud is the cumulation of years of development and production experience in [Atomix].

At the core of Atomix is the concept of _distributed primitives_: high-level reliable and scalable data 
structures and synchronization primitives for building distributed systems. Originally implemented only
in Java, Atomix Cloud brings a polyglot approach to the primitive APIs, defining a [Protobuf specification][API]
that can be implemented by clients and servers in a number of different languages. The distributed primitives
supported by Atomix Cloud include:

* Counters
* Leader election
* Lists
* Distributed locks
* Logs
* Maps
* Sets
* Values

In addition to the API specification, Atomix provides various implementations of the primitive API in 
the form of both backend databases and client libraries.

Backend protocols are generally implemented on state machine replication protocols using the
[Atomix Go framework](/go-framework). Backend implementations currently include:

* Raft (with implementations built on the [etcd][etcd Raft] and [Hashicorp][Hashicorp Raft] Raft implementations)
* Multi-Raft (built on [Dragonboat] Raft implementation)
* NOPaxos (custom Go implementation)

Additionally, the Atomix [Kubernetes controller][controller] supports backend proxies, allowing standalone
databases to be deployed to manage and persist distributed primitives.

Atomix Cloud clients can be implemented in any Protobuf/gRPC supported language. Client libraries
currently include:

* [Go client](/go-client)
* [Java client](/java-client)

[ONF]: https://opennetworking.org
[ONOS]: https://onosproject.org
[Atomix]: https://github.com/atomix/atomix
[Consul Raft]: https://github.com/hashicorp/raft
[Dragonboat]: https://github.com/lni/dragonboat
[etcd Raft]: https://github.com/etcd-io/etcd
[Hashicorp Raft]: https://github.com/hashicorp/raft
[Kubernetes]: https://kubernetes.io
[Protobuf]: https://developers.google.com/protocol-buffers
[gRPC]: https://grpc.io
[API]: /api
[controller]: /controller

</div>