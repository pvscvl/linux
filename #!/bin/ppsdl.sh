#!/bin/bash
#    bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/ppsdl.sh)"
# Download and sort the public keys from the webserver
keys=$(curl -s http://download.local/*.pub | sort)

# Sort the authorized keys file and compare with the downloaded keys
diff <(echo "$keys") <(sort ~/.ssh/authorized_keys) > /dev/null

# If the keys are different, add the missing ones to authorized_keys
if [[ $? -ne 0 ]]; then
    missing=$(comm -13 <(echo "$keys") <(sort ~/.ssh/authorized_keys))
    if [[ -n "$missing" ]]; then
        echo "Missing keys: $missing"
        echo "$missing" >> ~/.ssh/authorized_keys
    fi
else
    echo "All keys are already present in authorized_keys"
fi
