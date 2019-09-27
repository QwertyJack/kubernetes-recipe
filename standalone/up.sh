#!/bin/sh

vagrant up --no-provision --provider=libvirt
vagrant provision
