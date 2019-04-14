# mods.d

Installs various modifications to the system, so it's just the way I want it to be

## Files

Pretty simple bash with some headers

```sh
#!/bin/bash

# rerun: <target>
## When the script should be rerun. e.x. "upgrade" for upgrades
# version: <version>
## Give the script a version.
## If upgrade is set as rerun target then it will only rerun if the version has changed, or no version was set
