# Deployment

Atomix is built specifically for [Kubernetes], allowing it to take advantage of Kubernetes features like controllers,
custom resources, and more to create a seamless experience for users and administrators.

Atomix deployments consist of two types of components:
* Controller - Manages databases, clusters, and partitions
* Databases - A collection of nodes (i.e. pods) providing storage

## Deploying the Controller

To setup an Atomix database, first deploy the [controller] to your Kubernetes cluster. This can be done using
the default configuration provided in the controller repo:

```bash
$ kubectl create -f https://raw.githubusercontent.com/atomix/kubernetes-controller/master/deploy/atomix-controller.yaml
customresourcedefinition.apiextensions.k8s.io/databases.cloud.atomix.io created
customresourcedefinition.apiextensions.k8s.io/clusters.cloud.atomix.io created
customresourcedefinition.apiextensions.k8s.io/partitions.cloud.atomix.io created
clusterrole.rbac.authorization.k8s.io/atomix-controller created
clusterrolebinding.rbac.authorization.k8s.io/atomix-controller created
serviceaccount/atomix-controller created
deployment.apps/atomix-controller created
service/atomix-controller created
```

The default configuration will deploy a controller named `atomix-controller` in the
`kube-system` namespace. It will also configure the Kubernetes cluter with two custom
resource types: `PartitionSet` and `Partition`. Once the controller has been deployed,
it can be used to create Atomix partitions either using the Atomix client API or through
standard Kubernetes CLI and other APIs.

## Setting Up Databases

The role of an Atomix controller is to manage databases within the Kubernetes cluster. This
is done using [custom resources][custom-resources]. The controller adds three custom resources to the 
k8s cluster:
* `Database` defines a set of clusters and the protocol they implement
* `Cluster` defines a set of pods implementing a protocol
* `Partition` is a state partition within a cluster

Because the k8s controller uses custom resources for partition management, databases, clusters,
and partitions can be managed directly through the k8s API. To add a database via the
k8s API, simply define a `Database` object:

```yaml
apiVersion: cloud.atomix.io/v1beta1
kind: Database
metadata:
  name: raft
spec:
  clusters: 3
  template:
    spec:
      partitions: 10
      backend:
        replicas: 3
        image: atomix/raft-replica:latest
```

The `Database` spec mimics the templating patterns of core resources like `StatefulSet`. It can 
be configured with the number of `clusters` to deploy and a template for the cluster spec. 

The `Cluster` spec specifies how clusters within the database should be deployed. The spec 
indicates the number of state `partitions` in the cluster, and the images to deploy to replicate
state in the cluster. Clusters may be configured with two images:
* `backend` (required) - the backend replication protocol, e.g. Raft, etcd, ZooKeeper, etc
* `proxy` (optional) - a proxy image to manage traffic between clients and backend replicas

The example manifest above specifies a `Database` consisting of three `Cluster`s, each with
three replicas, and each with ten partitions. The database will deploy 9 total replicas and
partition state into 30 total partitions.

To create the database, use `kubectl` to create the resource:

```bash
$ kubectl create -f raft.yaml
database.cloud.atomix.io/raft created
```

Once the database has been created, you should be able to see it using normal `kubectl` commands:

```bash
$ kubectl get databases
NAME   AGE
raft   12s
```

The database will create the specified number of clusters:

```bash
$ kubectl get clusters
NAME     AGE
raft-1   30s
raft-2   30s
raft-3   30s
```

The database will create a number of partitions equal to the `clusters * partitions`:

```bash
$ kubectl get partitions
NAME       AGE
raft-1-0   57s
raft-1-1   57s
raft-1-2   57s
raft-1-3   57s
raft-1-4   57s
raft-1-5   57s
raft-1-6   57s
raft-1-7   57s
raft-1-8   57s
raft-1-9   57s
raft-2-0   57s
raft-2-1   57s
raft-2-2   57s
raft-2-3   57s
raft-2-4   57s
raft-2-5   57s
raft-2-6   57s
raft-2-7   57s
raft-2-8   57s
raft-2-9   57s
raft-3-0   57s
raft-3-1   57s
raft-3-2   57s
raft-3-3   57s
raft-3-4   57s
raft-3-5   57s
raft-3-6   57s
raft-3-7   57s
raft-3-8   57s
raft-3-9   57s
```

For each `Cluster` a `StatefulSet` will be created:

```bash
$ kubectl get statefulsets
NAME     READY   AGE
raft-1   1/1     2m11s
raft-2   1/1     2m11s
raft-3   1/1     2m11s
```

And each `StatefulSet` contains a number of pods equal to the cluster template's `replicas`:

```bash
$ kubectl get pods
NAME       READY   STATUS    RESTARTS   AGE
raft-1-0   1/1     Running   0          74s
raft-1-1   1/1     Running   0          74s
raft-1-2   1/1     Running   0          74s
raft-2-0   1/1     Running   0          74s
raft-2-1   1/1     Running   0          74s
raft-2-2   1/1     Running   0          74s
raft-3-0   1/1     Running   0          74s
raft-3-1   1/1     Running   0          74s
raft-3-2   1/1     Running   0          74s
...
```

A `Service` will be created for each cluster as well:

```bash
> kubectl get services
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
raft-1       ClusterIP   10.98.166.215   <none>        5678/TCP   95s
raft-2       ClusterIP   10.109.34.146   <none>        5678/TCP   95s
raft-3       ClusterIP   10.99.37.182    <none>        5678/TCP   95s
...
```

[controller]: /kubernetes-controller/overview
[Kubernetes]: https://kubernetes.io/
