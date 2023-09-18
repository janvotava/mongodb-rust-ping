<!--- app-name: mongodb-rust-ping&reg; -->

# MongoDB(R) Rust Ping Executable

Disclaimer: The respective trademarks mentioned in the offering are owned by the respective companies. We do not provide a commercial license for any of these products. This listing has an open-source license. MongoDB(R) is run and maintained by MongoDB, which is a completely separate project from SYNDIKAT7 GmbH.

## Introduction

This repo contains a mini rust executable which can replace the usage of mongosh as liveness probe for kubernetes.
As mongosh consumes a lot of resources and the footprint of deployed MongoDB(R) which use it for liveness probe
increase from 0.04 CPU to 0.4 and sometimes even 0.7 the motivation is there to switch to something more performant.  

### Customize Liveness Probe to use rust-executable:

In the example below, you can find how to use the custom rust-executable as livenessProbe

```yaml
initContainers:
  - name: copy-ping-tool
    image: ghcr.io/janvotava/mongodb-rust-ping:sha-f4d2bbb
    imagePullPolicy: IfNotPresent
    command:
      - cp
    args:
      - /usr/local/bin/mongodb-rust-ping
      - /custom-scripts
    volumeMounts:
      - mountPath: "/custom-scripts"
        name: mongodb-ping-volume
extraVolumeMounts:
  - name: mongodb-ping-volume
    mountPath: /custom-scripts
extraVolumes:
  - name: mongodb-ping-volume
    emptyDir: {}
livenessProbe:
  enabled: false
customLivenessProbe:
  initialDelaySeconds: 30
  periodSeconds: 20
  timeoutSeconds: 10
  failureThreshold: 6
  exec:
    command:
      - /custom-scripts/mongodb-rust-ping
readinessProbe:
  enabled: false
customReadinessProbe:
  initialDelaySeconds: 5
  periodSeconds: 20
  timeoutSeconds: 10
  failureThreshold: 6
  successThreshold: 1
  exec:
    command:
      - /custom-scripts/mongodb-rust-ping
```

## License - MIT

Copyright &copy; 2023 SYNDIKAT7 GmbH

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
