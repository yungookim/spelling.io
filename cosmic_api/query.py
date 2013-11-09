#!/usr/bin/python
from cosmic.api import API

client = API.load("http://127.0.0.1:5000/spec.json")
print client.actions.query("tyop")
