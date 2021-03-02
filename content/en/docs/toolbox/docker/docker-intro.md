# Docker Introduction

## Info's & Links

http://play-with-docker.com/

## Commands

### docker images

```sh
$ docker pull alpine
```

The `pull` command fetches the alpine image from the Docker registry and saves it in our system. You can use the `docker images` command to see a list of all images on your system.

```sh
$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
alpine                 latest              c51f86c28340        4 weeks ago         1.109 MB
hello-world             latest              690ed74de00f        5 months ago        960 B
```

### docker run

```sh
$ docker run alpine ls -l
total 48
drwxr-xr-x    2 root     root          4096 Mar  2 16:20 bin
drwxr-xr-x    5 root     root           360 Mar 18 09:47 dev
drwxr-xr-x   13 root     root          4096 Mar 18 09:47 etc
drwxr-xr-x    2 root     root          4096 Mar  2 16:20 home
drwxr-xr-x    5 root     root          4096 Mar  2 16:20 lib
......
```

```sh
$ docker run alpine echo "hello from alpine"
hello from alpine
```

```sh
$ docker run alpine /bin/sh
```

Nothing happened!?

#### Interactive Shells

Interactive shells will exit after running any scripted commands, unless they are run in an interactive terminal - so for this example to not exit, you need to `docker run -it alpine /bin/sh`

### docker ps

The docker ps command shows you all containers that are currently running.

```sh
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

Since no containers are running, you see a blank line. Let's try a more useful variant: `docker ps -a`

```sh
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES
36171a5da744        alpine              "/bin/sh"                5 minutes ago       Exited (0) 2 minutes ago                        fervent_newton
a6a9d46d0b2f        alpine             "echo 'hello from alp"    6 minutes ago       Exited (0) 6 minutes ago                        lonely_kilby
ff0a5c3750b9        alpine             "ls -l"                   8 minutes ago       Exited (0) 8 minutes ago                        elated_ramanujan
c317d0a9e3d2        hello-world         "/hello"                 34 seconds ago      Exited (0) 12 minutes ago                       stupefied_mcclintock
```

## Terminology

* *Images* - The file system and configuration of our application which are used to create containers. To find out more about a Docker image, run `docker inspect alpine`. In the demo above, you used the `docker pull` command to download the alpine image. When you executed the command `docker run hello-world`, it also did a `docker pull` behind the scenes to download the hello-world image.
* *Containers* - Running instances of Docker images — containers run the actual applications. A container includes an application and all of its dependencies. It shares the kernel with other containers, and runs as an isolated process in user space on the host OS. You created a container using `docker run` which you did using the alpine image that you downloaded. A list of running containers can be seen using the `docker ps` command.
* *Docker daemon* - The background service running on the host that manages building, running and distributing Docker containers.
* *Docker client* - The command line tool that allows the user to interact with the Docker daemon.
* *Docker Hub* - A registry of Docker images. You can think of the registry as a directory of all available Docker images. You'll be using this later in this tutorial.

# Training Operations

## Tmux cheatsheet

* Ctrl-b c → creates a new window
* Ctrl-b n → go to next window
* Ctrl-b p → go to previous window
* Ctrl-b " → split window top/bottom
* Ctrl-b % → split window left/right
* Ctrl-b Alt-1 → rearrange windows in columns
* Ctrl-b Alt-2 → rearrange windows in rows
* Ctrl-b arrows → navigate to other windows
* Ctrl-b d → detach session
* tmux attach → reattach to session

## Installation docker-machine

```sh
$ sudo -s
$ curl -L https://github.com/docker/machine/releases/download/v0.8.2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
chmod +x /usr/local/bin/docker-machine
```

## Installation docker-compose

```sh
$ sudo -s
$ curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
```

Or

```sh
$ sudo pip install docker-compose
```

## Other Tools Installation

`httping`

```sh
$ sudo apt-get install httping
```

## Docker Swarm

### Creating our first Swarm

* The cluster is initialized with `docker swarm init`
* This should be executed on a first, seed node
* *DO NOT* execute `docker swarm init` on multiple nodes!
* You would have multiple disjoint clusters.
* Create our cluster from node1:

```sh
$ docker swarm init
```

```sh
Error response from daemon: could not choose an IP address to advertise since this system has multiple addresses on interface eth0 (fd00::250:56ff:fea8:1c46 and 2003:ca:a3ed:fc00:250:56ff:fea8:1c46) - specify one with --advertise-addr
```

If Docker tells you that it could not choose an IP address to advertise, continue below!

```sh
$ docker swarm init --advertise-addr 192.168.1.61
```

```sh
Swarm initialized: current node (4ej3qp34s2s30qcwo42s6akbo) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-005krbcj317v7aqvm9yb1ikx30txlpxt7tqt0ohdsr5neg23ds-4obehd9es5l7izpqdxublrrma \
    192.168.1.61:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

#### `docker info`

```sh
$ docker info
Containers: 1
 Running: 0
 Paused: 0
 Stopped: 1
Images: 25
Server Version: 1.12.4
Storage Driver: aufs
 Root Dir: /var/lib/docker/aufs
 Backing Filesystem: extfs
 Dirs: 35
 Dirperm1 Supported: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: overlay null host bridge
Swarm: active
 NodeID: 4ej3qp34s2s30qcwo42s6akbo
 Is Manager: true
 ClusterID: 9703hu12rie128fuph46j3nvo
 Managers: 1
 Nodes: 1
 Orchestration:
  Task History Retention Limit: 5
 Raft:
  Snapshot Interval: 10000
  Heartbeat Tick: 1
  Election Tick: 3
 Dispatcher:
  Heartbeat Period: 5 seconds
 CA Configuration:
  Expiry Duration: 3 months
 Node Address: 192.168.1.61
Runtimes: runc
Default Runtime: runc
Security Options:
Kernel Version: 3.16.0-4-amd64
Operating System: Debian GNU/Linux 8 (jessie)
OSType: linux
Architecture: x86_64
CPUs: 4
Total Memory: 1.963 GiB
Name: n1
ID: HJXK:ZKF7:AV2F:66LW:7LW7:V7GD:L7X3:7MPY:Z2EV:4SH4:KHXK:2UWV
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
WARNING: No memory limit support
WARNING: No swap limit support
WARNING: No kernel memory limit support
WARNING: No oom kill disable support
WARNING: No cpu cfs quota support
WARNING: No cpu cfs period support
Insecure Registries:
 127.0.0.0/8
```

#### `docker node ls`

```sh
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
4ej3qp34s2s30qcwo42s6akbo *  n1        Ready   Active        Leader
```

### Adding Nodes to the Swarm

On node2

```sh
$ docker swarm join \
--token SWMTKN-1-005krbcj317v7aqvm9yb1ikx30txlpxt7tqt0ohdsr5neg23ds-4obehd9es5l7izpqdxublrrma \
192.168.1.61:2377
```

```sh
This node joined a swarm as a worker.
```

```sh
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
2eqqy6wgh02af2k7ahka0l8bl    n2        Ready   Active        
4ej3qp34s2s30qcwo42s6akbo *  n1        Ready   Active        Leader
```

### Adding Node to the Swarm via Docker API

Provisioning nodes with docker-machine

```sh
$ sudo docker-machine create --driver generic --generic-ip-address=192.168.1.61 --generic-ssh-key ~/.ssh/id_rsa n1
Running pre-create checks...
Creating machine...
(n1) Importing SSH key...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with debian...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env n1
```

```sh
$ docker-machine ls
NAME   ACTIVE   DRIVER    STATE     URL                       SWARM   DOCKER    ERRORS
n1     -        generic   Running   tcp://192.168.1.62:2376           v1.12.4   
n2     -        generic   Running   tcp://192.168.1.62:2376           v1.12.4   
n3     -        generic   Running   tcp://192.168.1.62:2376           v1.12.4   
n4     -        generic   Running   tcp://192.168.1.62:2376           v1.12.4   
n5     -        generic   Running   tcp://192.168.1.62:2376           v1.12.4
```

**Make sure we talk to the local node:**

```sh
$ eval $(docker-machine env -u)
```

Get the join token

```sh
$ TOKEN=$(docker swarm join-token -q worker)
$ echo $TOKEN
SWMTKN-1-005krbcj317v7aqvm9yb1ikx30txlpxt7tqt0ohdsr5neg23ds-4obehd9es5l7izpqdxublrrma
```

#### Adding the Nodes via the API

Communicate with node3

```sh
$ $eval $(docker-machine env n3)
```

Add node3 to the Swarm

```sh
docker swarm join --token $TOKEN n1:2377
```

Reset the environment variables

```sh
$ eval $(docker-machine env -u)
```

Check that the node is here

```sg
$ docker node ls
```

Adding the rest of the nodes... and finally all nodes are in the Swarm

```sg
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
2ahbvy7r97yjdjl56pzfvwbbo    n3        Ready   Active        
4ft723xvsrr29cdwarac1bnow    n5        Ready   Active        
bxh0uqlrirhtlzh64ww5leopn *  n1        Ready   Active        Leader
cbyn3dxf8al8pyknt66gwnd0g    n2        Ready   Active        
cskd7ownst57cl167z3cy97ug    n4        Ready   Active       
```

### Promoting Nodes

* Instead of adding a manager node, we can also promote existing workers
* Nodes can be promoted (and demoted) at any time

See the current list of nodes:

```sh
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
2ahbvy7r97yjdjl56pzfvwbbo    n3        Ready   Active        
4ft723xvsrr29cdwarac1bnow    n5        Ready   Active        
bxh0uqlrirhtlzh64ww5leopn *  n1        Ready   Active        Leader
cbyn3dxf8al8pyknt66gwnd0g    n2        Ready   Active        
cskd7ownst57cl167z3cy97ug    n4        Ready   Active
```

Promote the two worker nodes to be managers:

```sh
$ docker node promote 2ahbvy7r97yjdjl56pzfvwbbo 4ft723xvsrr29cdwarac1bnow
Node 2ahbvy7r97yjdjl56pzfvwbbo promoted to a manager in the swarm.
Node 4ft723xvsrr29cdwarac1bnow promoted to a manager in the swarm.
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
2ahbvy7r97yjdjl56pzfvwbbo    n3        Ready   Active        Reachable
4ft723xvsrr29cdwarac1bnow    n5        Ready   Active        Reachable
bxh0uqlrirhtlzh64ww5leopn *  n1        Ready   Active        Leader
cbyn3dxf8al8pyknt66gwnd0g    n2        Ready   Active        
cskd7ownst57cl167z3cy97ug    n4        Ready   Active
```

### Running a Swarm service

* How do we run services? Simplified version:
  `docker run` --> `docker service create`

```sh
$ docker service create alpine ping 8.8.8.8
6kvtl20xulxsx38h6fwqpcdgt
$ docker service ps 6kvtl20xulxsx38h6fwqpcdgt
ID                         NAME              IMAGE   NODE  DESIRED STATE  CURRENT STATE           ERROR
dfuauh9kmz3dxa26lo0k8i36i  cocky_thompson.1  alpine  n5    Running        Running 11 seconds ago
```

Service runs in node5

#### Checking container logs

ssh to node 5

```sh
$ docker ps
```

```sh
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
f99bbd00cf76        alpine:latest       "ping 8.8.8.8"      2 minutes ago       Up 2 minutes                            cocky_thompson.1.dfuauh9kmz3dxa26lo0k8i36i
$ docker logs f99bbd00cf76
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: seq=0 ttl=46 time=31.662 ms
....
```

#### Scaling the service

On node1 (again)

```sh
$ docker service update 6kvtl20xulxs --replicas 10
6kvtl20xulxs
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
c728d10482dc        alpine:latest       "ping 8.8.8.8"      8 seconds ago       Up 5 seconds                            cocky_thompson.5.d7itk6jbb84zywhe9qr2tem5w
b26d9a6c1e50        alpine:latest       "ping 8.8.8.8"      8 seconds ago       Up 5 seconds                            cocky_thompson.3.bf33me5ztinhd6vu8ucgtu9ua
$ docker service ls
ID            NAME            REPLICAS  IMAGE   COMMAND
6kvtl20xulxs  cocky_thompson  10/10     alpine  ping 8.8.8.8
$ docker service ps 6kvtl20xulxs
ID                         NAME               IMAGE   NODE  DESIRED STATE  CURRENT STATE               ERROR
dfuauh9kmz3dxa26lo0k8i36i  cocky_thompson.1   alpine  n5    Running        Running 9 minutes ago       
4oc9xuve2r1apyhd56sj95o9s  cocky_thompson.2   alpine  n3    Running        Running about a minute ago  
bf33me5ztinhd6vu8ucgtu9ua  cocky_thompson.3   alpine  n1    Running        Running about a minute ago  
afjd9fgluzeryibsgou2m5hbq  cocky_thompson.4   alpine  n2    Running        Running about a minute ago  
d7itk6jbb84zywhe9qr2tem5w  cocky_thompson.5   alpine  n1    Running        Running about a minute ago  
72uw3j9bt6puh0q627t3fajg7  cocky_thompson.6   alpine  n3    Running        Running about a minute ago  
09q8yy8azl985jokv5h0msetr  cocky_thompson.7   alpine  n4    Running        Running about a minute ago  
a3vzq6lgefai8d3tao79ef3qf  cocky_thompson.8   alpine  n4    Running        Running about a minute ago  
5rjyra1xh8rlqvwk1gml13kud  cocky_thompson.9   alpine  n5    Running        Running about a minute ago  
2rqgyh6se4pt2aupujty8y7k7  cocky_thompson.10  alpine  n2    Running        Running about a minute ago
```