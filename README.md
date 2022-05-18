# AKS Istio Sandbox


```bash
terraform init
terraform apply -auto-approve
```

``bash
kubectl label namespace default istio-injection=enabled
```


```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/platform/kube/bookinfo.yaml
```

```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/networking/bookinfo-gateway.yaml
```

```
istioctl analyze
```
