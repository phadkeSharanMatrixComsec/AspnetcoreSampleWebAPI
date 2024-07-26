# Sample Aspnetcore WebAPI

## For testing deployment 

AspnetCore WebAPI Docker Image Used : [aspnetcore-sample-image](https://hub.docker.com/repository/docker/phadkesharanmatrixcomsec/aspnetcore-sample/general)


## Nginx Ingress Controller 

[nginx ingress controller](https://kubernetes.github.io/ingress-nginx/deploy/)
[kubernetes docs](https://kubernetes.io/docs/concepts/)

## Steps for deploying on Minikube cluster

1. Install and start minikube 
- [install minikube](https://minikube.sigs.k8s.io/docs/start/)


2. Setup K8s deployment and Service

- setup kubectl alias `alias kubectl="minikube kubectl --"`

- apply namespace `kubectl apply -f deploy/minikube/namespace.yml`
- apply deployment `kubectl apply -f deploy/minikube/deployment-example.yml`
- apply service `kubectl apply -f deploy/minikube/service-example.yml`


3. Install minikube nginx ingress controller Add ON and apply ingress resource

- Install add on `minikube addons enable ingress`
- apply ingress `kubectl apply -f deploy/minikube/ingress-example.yml`
- inspect ingress and make sure external IP is assigned to it
- `kubectl get ingress -n aspnetcore`

4. Update host entries and access application

- Update /etc/hosts file to add this entry
- `<ingress-external-IP>        <ingress-host-name>`

- The Application will be accessible at http://ingress-host-name/



## Steps for deploying for on premise K8s cluster

1. Setup deployment, service and ingress resources
- `kubectl apply -f deploy/on-premise/deploy-aspnetcore-webapi.yml`
- apply ingress `kubectl apply -f deploy/on-premise/ingress-resource.yml`

2. Deploy nginx ingress controller : 
`kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/cloud/deploy.yaml`


For exposing your ingress to external network a Load Balancer is required.
It is normally taken care by the cloud provider service when using their managed K8s service
Eg AWS provides Elastic Load Balancer while using EKS (Elastic Kubernetes Service) 

[Read Bare metal Considerations](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/)

#### For on premise k8s cluster we have 2 viable options

1. Use NordPort and expose the service directly to one of the Worker Nodes of the cluster

- [expose using NodePort](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/#over-a-nodeport-service)

2. Use L2 software loadBalancer like metallb [metalLB](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/#a-pure-software-solution-metallb)

- Install metalLB in your cluster `kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
`

- Specify IP Address Pool for ingress in IPAddressPool resource and apply
- `kubectl apply -f deploy/on-premise/loadBalancer-metallb/ipaddress-pool.yml`

- Configure L2Advertisement resource
- `kubectl apply -f deploy/on-premise/loadBalancer-metallb/ipaddress-pool.yml`

- Inspect ingress and find external IP
- `kubect get ingress -n aspnetcore`

The Application will now have a starting point the externalIP of the ingress