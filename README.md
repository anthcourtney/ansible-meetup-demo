# ansible-meetup-poc

This is a Proof of Concept playbook for a contrived service, created purely for demonstration to the Sydney Ansible Meetup group.

## Branches

A couple of branches are available:

* ```master```` demonstrates testing a playbook in a vagrant enviornment, using functional tests to validate the outcome (rather than the implementation).
* ```block-tests``` demonstrates how the tests can be performed with evaluation of those tests delayed until the end (via the use of blocks).
* ```rolling-upgrade``` demonstrates (using a psuedo-code playbook) how functional tests could be run against a subset of hosts in a Production environment where HA was a concern.

## Dependencies

This playbook depends on a few (again, contrived) roles:

* ```common```. <https://github.com/anthcourtney/ansible-role-common>
* ```ntp```. <https://github.com/anthcourtney/ansible-role-ntp>
* ```nginx```. <https://github.com/anthcourtney/ansible-role-nginx>
* ```api```. <https://github.com/anthcourtney/ansible-role-api>

Note that the ```ntp``` role is the quoted example (in the presentation) for a role-orientated testing approach.

## Test

To test the playbook in a vagrant-environment

```
$ export USE_VM=true
$ make clean 
$ make create
$ make prepare
$ make converge
$ make test
```

or use the short-hand approach:

```
$ USE_VM=true make clean setup test
```

## Tox

To test the playbook against other versions of ansible (using tox), simply:

```
$ tox -l (to list available environments)
$ tox -e py27-ansible22 (test against ansible 2.2)
$ tox -e py27-ansibledevel (test against ansible devel branch)
```
