A very simple programme, able to be statically linked, that serves either a
blue, or a green, webpage on port 8080.

Useful for testing blue/green deployment mechanisms, or, deploying onto
machines that you otherwise couldn't tell apart.

## TODO
* :blank tag that has nothing in the environment so users can easily set
  their own (and because k8s will do a rolling update for an env change)
