
path    ?= $(shell pwd)
grant   ?= ${path}/grant.zip
callback?= ${path}/callback.zip
tfstate ?= terraform.tfstate
tfplan  ?= terraform.tfplan

lambda  ?= grant

profile ?= ...
region  ?= us-west-2

firebase_path ?= ...
firebase_auth ?= ...

example ?= transport-state

# -----------------------------------------------------------------------------

# Develop

build-dev:
	cd ${path}/examples/${example} && \
	npm install --production

run-dev:
	cd ${path}/examples/${example} && \
	FIREBASE_PATH=${firebase_path} \
	FIREBASE_AUTH=${firebase_auth} \
	npx serverless offline start

# -----------------------------------------------------------------------------

# Build

build-grant:
	rm -f ${grant}
	cd ${path}/examples/${example}/grant && \
	rm -rf node_modules && \
	npm install --production && \
	zip -r ${grant} node_modules grant.js config.json store.js

build-callback:
	rm -f ${callback}
	cd ${path}/examples/${example}/callback && \
	rm -rf node_modules && \
	npm install --production && \
	zip -r ${callback} node_modules callback.js store.js

# -----------------------------------------------------------------------------

# Terraform

init:
	cd ${path}/terraform/ && \
	terraform init

plan:
	cd ${path}/terraform/ && \
	TF_VAR_grant=${grant} \
	TF_VAR_callback=${callback} \
	TF_VAR_lambda=${lambda} \
	TF_VAR_region=${region} \
	TF_VAR_example=${example} \
	TF_VAR_firebase_path=${firebase_path} \
	TF_VAR_firebase_auth=${firebase_auth} \
	AWS_PROFILE=${profile} terraform plan \
	-state=${tfstate} \
	-out=${tfplan}

apply:
	cd ${path}/terraform/ && \
	TF_VAR_grant=${grant} \
	TF_VAR_callback=${callback} \
	TF_VAR_lambda=${lambda} \
	TF_VAR_region=${region} \
	TF_VAR_example=${example} \
	TF_VAR_firebase_path=${firebase_path} \
	TF_VAR_firebase_auth=${firebase_auth} \
	AWS_PROFILE=${profile} terraform apply \
	-state=${tfstate} \
	${tfplan}

destroy:
	cd ${path}/terraform/ && \
	TF_VAR_grant=${grant} \
	TF_VAR_callback=${callback} \
	TF_VAR_lambda=${lambda} \
	TF_VAR_region=${region} \
	TF_VAR_example=${example} \
	TF_VAR_firebase_path=${firebase_path} \
	TF_VAR_firebase_auth=${firebase_auth} \
	AWS_PROFILE=${profile} terraform destroy \
	-state=${tfstate}
