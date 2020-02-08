# Command Line Client (CLI)

Once a database has been deployed in your Kubernetes cluster, clients can create and operate
on distributed primitives. The simplest way to experiment with distributed primitives is using
the Atomix CLI.

## Deployment

While the Atomix CLI can be installed as a standalone executable, the simplest way to get
started with the CLI is by deploying it as a pod inside your Kubernetes cluster:

```bash
$ kubectl run atomix-cli --rm -it --image atomix/cli:latest --restart Never
```

## Configuration

By default, the CLI is deployed to connect to the default controller at
`atomix-controller.kube-system.svc.cluster.local:5679`. If you've deployed the controller
elsewhere (e.g. in a different namespace), use the `atomix config` commands to switch to
configure the controller:

```bash
$ atomix config get controller
atomix-controller.kube-system.svc.cluster.local:5679
$ atomix config set controller atomix-controller.my-namespace.svc.cluster.local:5679
atomix-controller.my-namespace.svc.cluster.local:5679
```

To set the default database, configure the `namespace` and `database` fields:

```bash
$ atomix config set namespace default
default
$ atomix config set database raft
raft
```

Scopes can be used to limit the visibility of distributed primitives and limit naming
collisions across applications. The application scope can be configured globally using
the `atomix config` commands:

```bash
$ atomix config set scope my-app
```

Once the CLI has been properly configured, you should be able to list databases and
the primitives in them:

```bash
$ atomix get databases
NAMESPACE   NAME
default     raft
$ atomix get primitives
NAME   SCOPE   TYPE
```

## Working with Primitives

The database has not yet been populated with any distributed primitives. To create a
new primitive, use the `atomix create` commands:

```bash
$ atomix create map my-map
Created map default.raft.my-app.my-map
```

The CLI provides commands for managing each distributed primitive:

```bash
$ atomix map -n my-map put "some-key" "some-value"
key: some-key
value: some-value
version: 12
$ atomix map -n my-map get "some-key"
key: some-key
value: some-value
version: 12
```

For synchronization primitives like locks or leader elections, open multiple CLI
sessions to test the locks:

#### Shell 1
```bash
$ atomix create lock my-lock
Created lock default.local.my-app.my-lock
$ atomix lock -n my-lock lock
Acquired lock 21
```

#### Shell 2
```bash
$ atomix lock -n my-lock lock
```

Note that _Shell 2_ does not immediately acquire the lock. Ctrl+C out of _Shell 1_
and _Shell 2_ will acquire the lock.

_See the  [CLI documentation](/cli/atomix) for a complete list of commands._
