#!/command/with-contenv sh

set -e

#User params
TIMEZONE=${TZ:="Asia/Shanghai"}

# Set Timezone
echo "${TIMEZONE}" > /etc/TZ
