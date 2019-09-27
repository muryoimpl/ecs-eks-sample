## EKS

### 前提作業

あらかじめ キーペアを作成しておく

### 構築

#### クラスタとノードの作成

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

# rolearn に NodeInstanceRol の ARN を書き込む
$ vim kube/aws-auth-cm.yml

# ワーカーノードをクラスターと結合する
$ kubectl apply -f kube/aws-auth-cm.yml

# node が作成されるのを確認する
$ kubectl get nodes --watch
```

#### アプリケーションの準備

```
$ echo -n "<SECRET_VALLUE>" | base64
$ vim kube/secrets.yml # base64 した値を書き込む
$ kubectl create -f kube/secrets.yml

$ kubectl apply -f kube/rails.yml
$ kubectl apply -f kube/rails-service.yml
$ kubectl apply -f kube/migration-job.yml

# migrationがうまくいかない場合は、下記コマンドを試す
$ kubectl get pods # pod の id を確認する
$ kubectl exec rails-xxxxxxxx -- bash -c 'cd lounge; bundle exec rails db:migrate'

# 下記コマンドで情報を確認し、LoadBalancer Ingress の値を使ってブラウザでアクセスするとアプリがみれる
$ kubectl describe services

# アプリのログを CloudWatch Logs に集約する。k8s という名前のstream ができる
$ curl https://raw.githubusercontent.com/fluent/fluentd-kubernetes-daemonset/master/fluentd-daemonset-cloudwatch-rbac.yaml > kube/fluentd-daemonset-cloudwatch-rbac.yaml
$ kubectl apply -f kube/fluentd-daemonset-cloudwatch-rbac.yaml
```
