# mods.d

Installs various modifications to the system, so it's just the way I want it to be

## Files

Pretty simple bash with some headers

```sh
#!/bin/bash

# rerun: <target>
## When the script should be rerun.
## - upgrade: on upgrades
## - watch-change: on watch changes, otherwise they just print alerts
# version: <version>
## Give the script a version.
## If upgrade is set as rerun target then it will only rerun if the version has changed, or no version was set
# watch-file: <path>
## watch a file for changes. e.g. /etc/default/grub. can be specified multiple times
```

Note that by default script files will always be re-run when they are changed, unless they have a specific condition attached (like `never` for never, `upgrade` only when the upgrade target is called)
