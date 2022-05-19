# AKS Istio Sandbox


```bash
terraform init
terraform apply -auto-approve
```

clone istio cli



az aks get-credentials -n aks-myapp -g rg-istiodemo



```bash
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
```



```bash
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
```

```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/networking/bookinfo-gateway.yaml
```

```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/networking/bookinfo-gateway.yaml
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