allows updating image versions in dockerman DB for composeman managed containers

see
https://github.com/dcflachs/compose_plugin/pull/27

##### Patching

the following patch needs to be applied under `/usr/local/emhttp/plugins/compose.manager`

1. run ansible playbook (optionally with with tag compose.patch) to copy `php/DockerUpdate.php`

2. Add following to the end of the `update` switch statement in `scripts/compose.sh` (just before `;;`)

```bash
# Update unRaid's local/remote image versions database so GUI shows correct info about updates
docker compose -p "$name" ps --format "{{.Image}}" | php /usr/local/emhttp/plugins/compose.manager/php/DockerUpdate.php 2>&1
```