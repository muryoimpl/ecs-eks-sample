## EKS

```
# stack を作成
$ ansible-playbook site.yml

# kubeconfig を作成
$ aws eks --region ap-northeast-1 update-kubeconfig --name esm-lounge-test

$ vim aws-auth-cm.yml
rolearn に NodeInstanceRol の ARN を書き込む

# ワーカーノードをクラスターと結合する
$ kubectl apply -f aws-auth-cm.yml

$ kubectl get nodes --watch
```
