clean: vagrant-destroy cleanup-roles

setup: requirements

test: syntax-check vagrant-up vagrant-provision idempotency-test functional-test

deploy: run-playbook

test-deploy: 
	${MAKE} deploy tags="functional-tests" extra_vars="run_tests=true"

# Helpers

## Setup 

requirements:
	@ansible-galaxy install -r requirements.yml -p roles -f

## Deployment

run-playbook:
ifdef tags
	@ansible-playbook -i inventory -t "${tags}" -e "${extra_vars}" site.yml
else
	@ansible-playbook -i inventory -e "${extra_vars}" site.yml
endif

## Tests

syntax-check:
	@echo 'Running syntax-check'
	@ansible-playbook -i localhost, --syntax-check --list-tasks site.yml \
	  && (echo 'Passed syntax-check'; exit 0) \
	  || (echo 'Failed syntax-check'; exit 1)

idempotency-test:
	@echo 'Running idempotency test'
	@${MAKE} vagrant-provision | tee /tmp/ansible_$$$$.txt; \
	grep -q 'changed=0.*failed=0' /tmp/ansible_$$$$.txt \
	  && (echo 'Passed idempotency test'; exit 0) \
	  || (echo "Failed idempotency test"; exit 1)

functional-test:
	@echo 'Running functional test'
	@RUN_TESTS=true ${MAKE} vagrant-provision \
	  && (echo 'Passed functional test'; exit 0) \
	  || (echo 'Failed functional test'; exit 1)

## Cleanup

cleanup-roles:
	@if [ -d roles ]; then rm -rf roles; fi

## Vagrant
	
vagrant-up:
	@vagrant up --no-provision

vagrant-destroy:
	@vagrant destroy -f

vagrant-provision:
	@vagrant provision

vagrant-ssh:
	@vagrant ssh
