#!/bin/bash

curl https://api.github.com/repos/oracle/graal/commits/master | jq '{sha: .sha}' > .tmp_graal
curl https://api.github.com/repos/micronaut-projects/micronaut-core/commits/master | jq '{sha: .sha}' > .tmp_micronaut

GRAAL_CURRENT_COMMIT=$(cat .graal_master_commit)
GRAAL_LAST_COMMIT=$(cat .tmp_graal)

MN_CURRENT_COMMIT=$(cat .mn_master_commit)
MN_LAST_COMMIT=$(cat .tmp_micronaut)

echo $GRAAL_CURRENT_COMMIT
echo $GRAAL_LAST_COMMIT
echo $MN_CURRENT_COMMIT
echo $MN_LAST_COMMIT

if [ "$GRAAL_CURRENT_COMMIT" == "$GRAAL_LAST_COMMIT" ] && [ "$MN_CURRENT_COMMIT" == "$MN_LAST_COMMIT" ]; then
	echo "finish the build"
	exit 127
else
	touch .trigger-build
fi;
