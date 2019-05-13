PWD=$(shell pwd)
ROLE_NAME=weareinteractive.php5-newrelic
ROLE_PATH=/etc/ansible/roles/$(ROLE_NAME)
TEST_VERSION=ansible --version
TEST_DEPS=ansible-galaxy install -c weareinteractive.apt franklinkim.php5 franklinkim.newrelic
TEST_SYNTAX=ansible-playbook -v -i 'localhost,' -c local $(ROLE_PATH)/tests/main.yml --syntax-check
TEST_PLAYBOOK=ansible-playbook -vvvv -i 'localhost,' -c local $(ROLE_PATH)/tests/main.yml
TEST_IDEMPOTENT=$(TEST_PLAYBOOK) | grep -q 'changed=0.*failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)
TEST_CMD=$(TEST_DEPS); $(TEST_VERSION); $(TEST_SYNTAX); $(TEST_DEPS); $(TEST_PLAYBOOK); $(TEST_IDEMPOTENT)

ubuntu14.04: dist=ubuntu-14.04
ubuntu14.04: .run

ubuntu16.04: dist=ubuntu-16.04
ubuntu16.04: .run

.run:
	@echo "RUN:"
	@echo "	docker run -it --rm -v $(PWD):$(ROLE_PATH) ansiblecheck/ansiblecheck:$(dist) /bin/bash"
	@echo "	$(TEST_CMD)"
	@docker run -it --rm -v $(PWD):$(ROLE_PATH) ansiblecheck/ansiblecheck:$(dist) /bin/bash -c "$(TEST_CMD)"
