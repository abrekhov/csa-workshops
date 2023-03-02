.DEFAULT_GOAL=apply

source:
	. ./init-env.sh
plan: source
	terraform plan 
apply: source
	terraform apply -auto-approve
destroy: source
	terraform destroy -auto-approve