# AKS Istio Sandbox

To install Azure resources and Helm charts (repeat for each one):

```bash
terraform init
terraform apply -auto-approve
```

Connect to AKS:

```bash
az aks get-credentials -n aks-myapp -g rg-istiodemo
```

Clone Istioctl and apply the BookInfo manifests:


```bash
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
```

```
istioctl analyze
```


### Minikube

If you're running on Minikube you're gonna need more juice:

```sh
minikube start --memory 8192 --cpus 2
```

For more options [this article](https://www.shellhacks.com/minikube-start-with-more-memory-cpus/) may help.