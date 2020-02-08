# Architecture

Atomix is a Kubernetes-native database, and as such it integrates closely with
Kubernetes features to simplify cluster management.

## Distributed Primitives

At the core of Atomix is the concept of distributed primitives. Primitives are
high-level objects that facilitate persistence and coordination in distributed
systems. The [primitive API][API] is specified by a protocol-independent [Protobuf] 
services and is implemented by database nodes to store and replicate primitive state.

The remaining details of the Atomix architecture are designed to facilitate the 
persistence, scalability, and usability of distributed primitives.

## Controller

Atomix databases are managed by a central service called the [controller]. The
controller manages databases using custom Kubernetes resources and implements the
service discovery [API] for Atomix clients.

![Controller](/images/Controller.png)

When [database](#databases) resources are created, the controller creates the
necessary Kubernetes resources to run the database.

## Databases

Databases are custom Kubernetes resources that provide storage for a collection of
primitives. Each database may consist of one or more `Cluster`s, and each cluster
of one or more `Partition`s.

![Resources](/images/Resources.png)

A `Cluster` is implemented as a `StatefulSet` with an optional proxy node, 
depending on the database implementation. A `Partition` is a division of the
state space within a cluster which provides an independent implementation of
the underlying protocol.

## Partitioning

Partitions are divisions of the state space within clusters and databases.
When a client connects to a [database](#databases), the [controller](#controller)
provides the client with a list of partitions in the database. 
[Primitive](#distributed-primitives) perform client-side partitioning, spreading
state across all the partitions if possible.

![Partitioning](/images/Partitioning.png)

Partitioning state allows for concurrency within databases, enabling scalability
even while strong consistency is guaranteed.

[Kubernetes]: https://kubernetes.io
[Protobuf]: https://developers.google.com/protocol-buffers
[controller]: /controller/overview
[API]: /api/overview
