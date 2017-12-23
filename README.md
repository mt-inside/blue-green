A very simple programme, able to be statically linked, that serves either a
blue, or a green, webpage on port 8080.

Useful for testing blue/green deployment mechanisms, or, deploying onto
machines that you otherwise couldn't tell apart.

## TODO
* Read colour from the environment, 12-factor style, template into the
  HTML. This will allow the big fs layer (the go programme) to be shared
  between both tags, assuming the ENV statement is put after COPY.
