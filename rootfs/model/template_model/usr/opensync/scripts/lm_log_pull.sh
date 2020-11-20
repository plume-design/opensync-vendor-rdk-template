#!/bin/sh

# Copyright (c) 2019, Plume Design Inc. All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#    1. Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#    2. Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#    3. Neither the name of the Plume Design Inc. nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL Plume Design Inc. BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#
# Log-pull script for RDK

Usage() {
    echo "Usage: lm_log_pull.sh <upload-url> <upload-token> [status-dir]"
    exit 1
}

log() {
    echo "lm_log_pull: $*"
}

error_out() {
    log "ERROR - $*"
    exit 1
}

collect_cmd() {
    _outfn="$LM_PULL_DIR/$(echo -n "$*" | tr -C "A-Za-z0-9.-" _)"
    "$@" > "${_outfn}" 2>&1
}

[ $# -eq 0 ] && Usage
LM_UPLOAD_URL="$1"; shift

[ $# -eq 0 ] && Usage
LM_UPLOAD_TOKEN="$(basename $1)"; shift

LM_STATUS_DIR="$1"; shift
[ $# -ne 0 ] && Usage

LM_TEMP_DIR="/tmp/lm"
LM_TSTAMP="$(date +'%Y%m%d_%H%M%S')"
LM_PULL_NAME="pull_${LM_TSTAMP}"
LM_PULL_DIR="${LM_TEMP_DIR}/${LM_PULL_NAME}"

log "Pulling into ${LM_PULL_DIR}..."
mkdir -p "${LM_PULL_DIR}" || error_out "failed to create ${LM_PULL_DIR}"
cd "${LM_PULL_DIR}"

# First handle syslog, for example using journalctl
journalctl > messages_${LM_TSTAMP}

### Now handle collection from commands

# OVSDB
collect_cmd ovsdb-client dump
collect_cmd ovsdb-client -f json dump

# Networking
collect_cmd ifconfig -a
collect_cmd ip -d link show
collect_cmd route -n
collect_cmd arp -an
collect_cmd brctl show

# System
collect_cmd ps wl
collect_cmd top -n1
collect_cmd free
collect_cmd df -h
collect_cmd dmesg
collect_cmd cat /etc/resolv.conf
collect_cmd cat /nvram/dnsmasq.leases

# Wireless
collect_cmd iwconfig
collect_cmd iw dev

# Device info
for x in -mo -sn -fw -ms -mu -cmac -cip -cipv6 -emac -eip -eipv6 -lmac -lip -lipv6; do
    collect_cmd deviceinfo.sh $x
done

# status files
if [ -n "${LM_STATUS_DIR}" -a -d "${LM_STATUS_DIR}" ]; then
    mv "${LM_STATUS_DIR}"/* "${LM_PULL_DIR}"/
fi

# RDK Logs
if [ -d /rdklogs/logs ]; then
    cp -dpR /rdklogs/logs "${LM_PULL_DIR}/rdklogs"
fi

# Collect kconfig
cp -f /usr/opensync/etc/kconfig ${LM_PULL_DIR}

# Collect all core dump files
mkdir -p Core
mv /tmp/*.core.gz  Core/

# Create tarball
log "Creating tarball: ${LM_UPLOAD_TOKEN}"
cd $LM_TEMP_DIR || error_out
tar -czf "$LM_UPLOAD_TOKEN" "$LM_PULL_NAME"

# Upload tarball
log "Uploading tarball to ${LM_UPLOAD_URL}"
curl --cacert /usr/opensync/etc/certs/upload.pem --cert /usr/opensync/etc/certs/client.pem --key /usr/opensync/etc/certs/client_dec.key -v -F filename=@${LM_UPLOAD_TOKEN} $LM_UPLOAD_URL || log "Upload failed!!"

# Cleanup
log "Cleaning up"
cd "$LM_TEMP_DIR" || error_out
rm -rf "${LM_PULL_DIR}"
rm -f "${LM_UPLOAD_TOKEN}"

exit 0
