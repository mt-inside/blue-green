A very simple programme, able to be statically linked, that serves either a
blue, or a green, webpage on port 8080.

Useful for testing blue/green deployment mechanisms, or, deploying onto
machines that you otherwise couldn't tell apart.

## TODO
* :blank tag cause why not (will crash by default)
* also read color from disk (no error handling), 2nd preference to env
* also read color from cmdline (not even flag parsing) (0th preference)
* avoid browser caching. Something like
```cache-control: no-cache, no-store, must-revalidate
content-length: 98980
content-type: application/javascript
date: Tue, 31 Mar 2020 13:59:52 GMT
expires: 0
last-modified: Thu, 01 Jan 1970 00:00:01 GMT
pragma: no-cache```
