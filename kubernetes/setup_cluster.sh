echo "Setup the kubernetes cluster"
gcloud beta container --project "secretsanta-web" clusters create "secretsanta-cluster" \
  --region "us-central1" \
  --no-enable-basic-auth \
  --cluster-version "1.12.7-gke.7" \
  --machine-type "custom-1-1024" \
  --image-type "COS" \
  --disk-type "pd-ssd" \
  --disk-size "10" \
  --metadata disable-legacy-endpoints=true \
  --scopes "https://www.googleapis.com/auth/cloud-platform" \
  --preemptible \
  --num-nodes "1" \
  --enable-cloud-logging \
  --enable-cloud-monitoring \
  --enable-ip-alias \
  --network "projects/secretsanta-web/global/networks/secretsanta-web-us" \
  --subnetwork "projects/secretsanta-web/regions/us-central1/subnetworks/secretsanta-web-us" \
  --default-max-pods-per-node "110" \
  --enable-autoscaling \
  --min-nodes "1" \
  --max-nodes "3" \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing \
  --enable-autoupgrade \
  --enable-autorepair

echo "\nSetting up services, config, and load balancing"
echo "-----------------------------------------------"
kubectl apply -f database.yml
kubectl apply -f redis.yml
kubectl apply -f routes.yml
kubectl apply -f web.yml

echo "Done. All setup and ready to go! 🎉"
