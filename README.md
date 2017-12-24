A very simple programme, able to be statically linked, that serves either a
blue, or a green, webpage on port 8080.

Useful for testing blue/green deployment mechanisms, or, deploying onto
machines that you otherwise couldn't tell apart.

## TODO
* /api/v1 endpoint that returns type:application/json { colour: blue }
* /healthz endpoint that returns 200
* /healthz-slow endpoint that returns 200s after the 5th request
* /healthz-broken endpoint that returns 500s for ever
* :blank tag that has nothing in the environment so users can easily set
  their own (and because k8s will do a rolling update for an env change)
