#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

cleanup() {
    kill TERM "$openvpn_pid"
    exit 0
}

is_enabled() {
    [[ ${1,,} =~ ^(true|t|yes|y|1|on|enable|enabled)$ ]]
}

NORDVPN_SERVER=$(echo $NORDVPN_SERVER | tr '[:upper:]' '[:lower:]')
OPENVPN_TECHNOLOGY=$(echo $OPENVPN_TECHNOLOGY | tr '[:upper:]' '[:lower:]')
NORDVPN_OPENVPN_CONFIG=$NORDVPN_SERVER.nordvpn.com.$OPENVPN_TECHNOLOGY.ovpn

echo "Using NordVPN configuration: $NORDVPN_OPENVPN_CONFIG"
echo

echo -e "$OPENVPN_USERNAME\n$OPENVPN_PASSWORD" > /etc/openvpn/credentials.txt
chmod 600 /etc/openvpn/credentials.txt

openvpn_args=(
    "--config" "/etc/openvpn/ovpn_$OPENVPN_TECHNOLOGY/$NORDVPN_OPENVPN_CONFIG"
    "--auth-user-pass" "/etc/openvpn/credentials.txt"
)

if is_enabled "$KILL_SWITCH"; then
    openvpn_args+=("--route-up" "/usr/local/bin/killswitch.sh $ALLOWED_SUBNETS")
fi

openvpn "${openvpn_args[@]}" &
openvpn_pid=$!

trap cleanup TERM

wait $openvpn_pid
