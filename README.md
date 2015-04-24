hs-aurora-thrift
================

```
cabal build
dist/build/aurora-thrift/aurora-thrift
xdg-open http://localhost:8000
```

API
---

### GET `/jobs`
List all jobs.

### POST `/create`
Post a task spec of the form:

```
{
    "name": "hello",
    "command": "/bin/echo hello world",
    "resources": {
        "disk": "10",
        "ram": "10",
        "cpu": "0.1"
    }
}
```