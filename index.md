---
layout: default
---

# TL;DR

To install anycable-go to your kubernetes cluster simply run:

```shell
helm repo add anycable https://helm.anycable.io/

# With Helm 3
helm upgrade -i anycable-go anycable/anycable-go

# With Helm 2
helm upgrade -i --name anycable-go anycable/anycable-go
```

More info is available at GitHub page for [anycable/anycable-helm](https://github.com/anycable/anycable-helm).
