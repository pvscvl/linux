wget http://dns.local:5380/api/settings/backup\?token\=0509381aa2e5882bad0d8fb0b5b82e24eb7a4a04eecde2699d19b04705000c51\&blockLists\=true\&logs\=true\&scopes\=true\&stats\=true\&zones\=true\&allowedZones\=true\&blockedZones\=true\&dnsSettings\=true\&logSettings\=false\&authConfig\=true
dnsconfname=./backup\?token=0509381aa2e5882bad0d8fb0b5b82e24eb7a4a04eecde2699d19b04705000c51\&blockLists=true\&logs=true\&scopes=true\&stats=true\&zones=true\&allowedZones=true\&blockedZones=true\&dnsSettings=true\&logSettings=false\&authConfig=true
mv $dnsconfname ./"$(date +%F)_Technitium-conf.zip"
