# Summary

apply https://github.com/dcflachs/compose_plugin/pull/27

under /usr/local/emhttp/plugins/compose.manager 

on every reboot

### patch details

* copy php/DockerUpdate.php
* patch scripts/compose.sh
  * insert `docker compose -p "$name" ps --format "{{.Image}}" | php /usr/local/emhttp/plugins/compose.manager/php/DockerUpdate.php 2>&1` as last step in `update)` section (line 138)
