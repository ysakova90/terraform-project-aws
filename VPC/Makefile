clean-up:
	find / -type d -name ".terraform" -exec rm -rf {} \;


	
sydney:
	terraform  workspace  select sydney   || terraform  workspace  new sydney   
	terraform init 
	terraform apply     -var-file     envs/sydney.tfvars     -auto-approve


ohio:
	terraform  workspace  select ohio   || terraform  workspace  new ohio  
	terraform init 
	terraform apply     -var-file     envs/ohio.tfvars     -auto-approve


london:
	terraform  workspace  select london   || terraform  workspace  new london  
	terraform init 
	terraform apply     -var-file     envs/london.tfvars     -auto-approve

frankfurt:
	terraform  workspace  select frankfurt   || terraform  workspace  new frankfurt  
	terraform init 
	terraform apply     -var-file     envs/frankfurt.tfvars     -auto-approve


all:
	make sydney 
	make ohio 
	make london
	make frankfurt


destroy-sydney:
	terraform  workspace  select sydney   
	terraform init 
	terraform destroy     -var-file     envs/sydney.tfvars     -auto-approve


destroy-ohio:
	terraform  workspace  select ohio   
	terraform init 
	terraform destroy     -var-file     envs/ohio.tfvars     -auto-approve


destroy-london:
	terraform  workspace  select london   
	terraform init 
	terraform destroy     -var-file     envs/london.tfvars     -auto-approve

destroy-frankfurt:
	terraform  workspace  select frankfurt   
	terraform init 
	terraform destroy     -var-file     envs/frankfurt.tfvars     -auto-approve


destroy-all:
	make destroy-sydney
	make destroy-ohio
	make destroy-london
	make destroy-frankfurt