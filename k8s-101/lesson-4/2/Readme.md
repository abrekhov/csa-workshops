# StatefullSet


cd ../2/

Let's create ns

```sh
kubectl create -f 02-ns.yaml
```

Let's study the files to run sts

```sh
kubectl create -f 02-cm-svc.yaml
```

Run sts itself and wait for it to create all the pods
```sh
kubectl create -f 02-sts.yaml
watch kubectl get pods -l app=mysql -n demo-ns # run in tab
```

When will type inference

```
NAME READY STATUS RESTARTS AGE
mysql-0 2/2 Running 0 2m
mysql-1 2/2 Running 0 1m
mysql-2 2/2 Running 0 1m
```
That means everything is working.
Let's look at PVC - as you can see, 3 of them have been created


```
kubectl get pvc -n demo-ns
NAME STATUS VOLUME CAPACITY ACCESS MODES STORAGECLASS AGE
data-mysql-0 Bound pvc-fe0e63a7-831a-4b22-8841-e6fb60ee8109 10Gi RWO yc-network-ssd 12m
data-mysql-1 Bound pvc-6cc27a0b-20ef-4b5d-9d08-8d869085345b 10Gi RWO yc-network-ssd 11m
data-mysql-2 Bound pvc-ab02379b-efde-404b-8e5d-afa9e2e0466e 10Gi RWO yc-network-ssd 9m26s

```

Write to the master (under mysql-0) a message

```
kubectl run mysql-client --image=mysql:5.7 -i --rm --restart=Never --\
   mysql -h mysql-0.mysql.demo-ns <<EOF
CREATE DATABASE test;
CREATE TABLE test.messages (message VARCHAR(250));
INSERT INTO test.messages VALUES('hello');
EOF
```

Read from replicas (mysql-read service) message
```
kubectl run mysql-client --image=mysql:5.7 -i -t --rm --restart=Never --\
   mysql -h mysql-read.demo-ns -e "SELECT * FROM test.messages"
```

Make sure that requests to replicas are randomly distributed

```
kubectl run mysql-client-loop --image=mysql:5.7 -i -t --rm --restart=Never --\
   bash -ic "while sleep 1; do mysql -h mysql-read.demo-ns -e 'SELECT @@server_id,NOW()'; done"
```

We will see random serverids here


```
kubectl run mysql-client-loop --image=mysql:5.7 -i -t --rm --restart=Never --\
      bash -ic "while sleep 1; do mysql -h mysql-read.demo-ns -e 'SELECT @@server_id,NOW()'; done"
If you don't see a command prompt, try pressing enter.
```
```
+-------------+---------------------+
| @@server_id | NOW() |
+-------------+---------------------+
| 101 | 2020-08-24 16:32:17 |
+-------------+---------------------+
+-------------+---------------------+
| @@server_id | NOW() |
+-------------+---------------------+
| 100 | 2020-08-24 16:32:18 |
+-------------+---------------------+
+-------------+---------------------+
| @@server_id | NOW() |
+-------------+---------------------+
| 102 | 2020-08-24 16:32:19 |
+-------------+---------------------+
```
Scale the base horizontally up

```
kubectl scale statefulset mysql --replicas=5 -n demo-ns
```

We see that gradually the request to the database began to issue new server_id ( 103 and 104)

Let's look at PVC - as you can see, there are already 5 of them


```
kubectl get pvc -n demo-ns
```

Scale the base horizontally down and observe

```
kubectl scale statefulset mysql --replicas=3 -n demo-ns
```
New server_id missing from database

and the old PVCs are expected to remain

```
kubectl get pvc -n demo-ns
```

Let's clean the lab

```
kubectl delete ns demo-ns
```