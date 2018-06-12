# Deployment and Integration with Other Services

## Load Balancing

Load balancers should round robin requests to all hummingbird proxy nodes.  Load balancers can also test connectivity to a proxy by making an HTTP request to `http://PROXY_IP/healthcheck`.

A sample config for HAProxy might look like:

```
defaults
        log     global
        mode    http
        option  dontlognull
        option http-keep-alive
        option  tcp-smart-accept
        option  tcp-smart-connect
        option  accept-invalid-http-response
        option splice-auto
        timeout connect 5000
        timeout client  90000
        timeout server  90000
        retries 3
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

listen swift_proxy_cluster
        bind 10.2.2.10:80
        balance  roundrobin
        maxconn 2000000
        option  tcpka
        option  forwardfor
        option  http-keep-alive
        timeout http-keep-alive 6000
        server storage1-z1.awesomestorage.com 10.1.1.113:8080 check inter 2000 rise 2 fall 5
        server storage1-z2.awesomestorage.com 10.1.1.114:8080 check inter 2000 rise 2 fall 5
        server storage1-z3.awesomestorage.com 10.1.1.115:8080 check inter 2000 rise 2 fall 5 
```

## Keystone

An object store endpoint that points to the hummingbird cluster needs to be created in Keystone.  For a cluster that has a public IP of `10.2.2.10` and private IP space of `10.1.1.10` the commands might look like:

```
openstack service create --name swift --description "Object Storage Service" object-store
openstack endpoint create --region RegionOne swift public "$HTTP://10.2.2.10/v1/AUTH_\$(tenant_id)s
openstack endpoint create --region RegionOne swift internal "$HTTP://10.1.1.10/v1/AUTH_\$(tenant_id)s"
openstack endpoint create --region RegionOne swift admin "$HTTP://10.1.1.10/v1"
```

A service account will need to be created that allows Hummingbird to make calls to Keystone to authenticate requests.

```
enstack project create service  --domain default
openstack user create --domain default --password password  --project service swift
openstack role add --project service --user swift admin
```

## Glance

Here are sample glance configs to use hummingbird as the backend store:

`glance-api.conf`
```
[glance_store]

stores = swift
default_store = swift
default_swift_reference = ref1
swift_store_create_container_on_put = True
swift_store_config_file = /etc/glance/glance-swift-store.conf
```

`glance-swift-store.conf`
```
[ref1]
user_domain_id = default
project_domain_id = default
auth_version = 3
auth_address = http://10.2.2.15/v3
key = your-password
user = service:glance-swift
```
