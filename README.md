
export AWS_ACCESS_KEY_ID=AKIA3AOCW2I6R753UANM
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-east-1

docker run -it \
  -v ${PWD}:/app \
  -w /app \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
  hashicorp/terraform init

docker run -it \
  -v ${PWD}:/app \
  -w /app \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
  hashicorp/terraform apply -auto-approve