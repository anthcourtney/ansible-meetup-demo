clean: cleanup-roles
ifeq ($(USE_VAGRANT),true)
	${MAKE} vagrant-destroy 
endif

create: 
ifeq ($(USE_VAGRANT),true)
	${MAKE} vagrant-up
endif

prepare: requirements syntax-check

converge:
ifeq ($(USE_VAGRANT),true)
	@${MAKE} vagrant-provision
else
	@${MAKE} run-playbook
endif

test:
ifeq ($(USE_VAGRANT),true)
	@${MAKE} idempotency-test
endif
	@${MAKE} functional-test

# Create helpers
vagrant-up:
	@vagrant up --no-provision

# Prepare helpers

requirements:
	@ansible-galaxy install -r requirements.yml -p roles -f

syntax-check:
	@echo 'Running syntax-check'
	@ansible-playbook -i localhost, --syntax-check --list-tasks site.yml \
	  && (echo 'Passed syntax-check'; exit 0) \
	  || (echo 'Failed syntax-check'; exit 1)

# Converge helpers

vagrant-provision:
	@vagrant provision

run-playbook:
ifdef tags
	@ansible-playbook -i inventory -t "${tags}" -e "${extra_vars}" site.yml
else
	@ansible-playbook -i inventory -e "${extra_vars}" site.yml
endif

## Test helpers

idempotency-test:
	@echo 'Running idempotency test'
	@${MAKE} vagrant-provision | tee /tmp/ansible_$$$$.txt; \
	grep -q 'changed=0.*failed=0' /tmp/ansible_$$$$.txt \
	  && (echo 'Passed idempotency test'; exit 0) \
	  || (echo "Failed idempotency test"; exit 1)

functional-test:
	@echo 'Running functional test'
ifeq ($(USE_VAGRANT),true)
	@${MAKE} functional-test-vagrant
else
	@${MAKE} functional-test-non-vagrant
endif

functional-test-vagrant:
	@RUN_TESTS=true ${MAKE} vagrant-provision \
	  && (echo 'Passed functional test'; exit 0) \
	  || (echo 'Failed functional test'; exit 1)

functional-test-non-vagrant:
	@${MAKE} run_playbook tags="functional-tests" extra_vars="run_tests=true" \
	&& (echo 'Passed functional test'; exit 0) \
	|| (echo 'Failed functional test'; exit 1)

## Clean helpers

cleanup-roles:
	@if [ -d roles ]; then rm -rf roles; fi
	
vagrant-destroy:
	@vagrant destroy -f

# Misc

vagrant-ssh:
	@vagrant ssh
