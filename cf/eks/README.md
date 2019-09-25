## EKS

### 前提作業

あらかじめ キーペアを作成しておく

### 構築

ref: https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/getting-started-console.html

1. https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-02-11/amazon-eks-vpc-private-subnets.yaml を使ってVPCを作成する
2. コンソールから EKS クラスタを作成する
3. kubeconfig を作成する
4. https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-02-11/amazon-eks-nodegroup.yaml を使って nodegroup を作成する
5. curl -o aws-auth-cm.yaml https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-02-11/aws-auth-cm.yaml を使って、ワーカーノードとクラスタを結合する
6. RDS を作成する

このとき、1) 作業を同一のユーザで実行しなければならない、2) ClusterName を統一する、を守らないとノードの情報が取得できない等の問題が発生する

```
# kubeconfig を作成
$ aws eks --region ap-northeast-1 update-kubeconfig --name eks-test

$ vim kube/01-aws-auth-configmap.yml
rolearn に NodeInstanceRol の ARN を書き込む

# ワーカーノードをクラスターと結合する
$ kubectl apply -f kube/01-aws-auth-cm.yml

$ kubectl get nodes --watch
```

```
$ echo -n "<SECRET_VALLUE>" | base64
$ vim secret.yml # base64 した値を書き込む
$ kubectl create -f kube/secrets.yml

$ kubectl apply -f kube/rails.yml
$ kubectl apply -f kube/rails-service.yml
$ kubectl apply -f kube/migration-job.yml

$ kubectl describe services
# LoadBalancer Ingress の値を使って ブラウザでアクセスするとアプリがみれる
```


