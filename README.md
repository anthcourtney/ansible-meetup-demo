# ansible-meetup-poc

This is a Proof of Concept playbook for a contrived service, created purely for demonstration to the Sydney Ansible Meetup group.

## Branch

This branch ```block-tests``` demonstrates how the tests can be performed with evaluation of those tests delayed until the end (via the use of blocks).

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
$ USE_VM=true make clean test
```

