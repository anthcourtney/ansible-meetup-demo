# Main goals

clean: vagrant-destroy

setup: requirements

test: test-requirements vagrant-up syntax-check vagrant-provision idempotency-test integration-test

go: run-playbook

# Helper goals

## Setup 

requirements:
	@ansible-galaxy install -r requirements.yml -p roles -f

test-requirements:
	@ansible-galaxy install -r tests/requirements.yml -p tests/roles -f

## Deployment

run-playbook:
	@ansible-playbook -i inventory site.yml

## Tests

syntax-check:
	@echo 'Running syntax-check'
	@cd tests && ansible-playbook -i localhost, --syntax-check --list-tasks site.yml \
	  && (echo 'Passed syntax-check'; exit 0) \
	  || (echo 'Failed syntax-check'; exit 1)

idempotency-test:
	@echo 'Running idempotency test'
	@${MAKE} vagrant-provision | tee /tmp/ansible_$$$$.txt; \
	grep -q 'changed=0.*failed=0' /tmp/ansible_$$$$.txt \
	  && (echo 'Passed idempotency test'; exit 0) \
	  || (echo "Failed idempotency test"; exit 1)

integration-test:
	@echo 'Running integration test'
	@RUN_TESTS=true ${MAKE} vagrant-provision \
	  && (echo 'Passed integration test'; exit 0) \
	  || (echo 'Failed integration test'; exit 1)

## Vagrant
	
vagrant-up:
	@cd tests && vagrant up --no-provision

vagrant-destroy:
	@cd tests && vagrant destroy -f

vagrant-provision:
	@cd tests && vagrant provision

vagrant-ssh:
	@cd tests && vagrant ssh
