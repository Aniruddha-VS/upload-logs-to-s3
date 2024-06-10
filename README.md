# A Log Collector for all worker nodes on a Kubernetes Cluster on a daily basis

Defaults:

1. Uplaod Schedule: Every night at 23:59 (can be updated in crontab file)
2. Available AWS Role with STSAssume policy attached and privileged Role ARN to get short term s3 write access.

How to use it:

1. Build the docker image
   
  docker build \<your-docker-repo\>/log-collector:v01 .

2. Upload to your docker repo

   docker push <your-docker-repo>/log-collector:v01

3. Update the secrets.yaml with your AWS IAM Role access key and Secret Key

4. Update configmap.yaml with your s3 bucket name, s3 region name and Role ARN.
 
5. Update image in Daemonset.yaml with <your-docker-repo>/log-collector:v01

6. Apply the files in your kubernetes cluster

   kubectl apply -f manifests/
