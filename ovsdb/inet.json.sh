
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

cat << EOF
[
    "Open_vSwitch",
    {
        "op":"insert",
        "table":"Wifi_Inet_Config",
        "row": {
            "if_name": "$CONFIG_RDK_LAN_BRIDGE_NAME",
            "ip_assign_scheme": "static",
            "if_type": "vif",
            "enabled": false
       }
    },
    {
        "op":"insert",
        "table":"Wifi_Inet_Config",
        "row": {
            "if_name": "$CONFIG_RDK_WAN_BRIDGE_NAME",
            "ip_assign_scheme": "static",
            "if_type": "vif",
            "enabled": false
       }
    },
    {
        "op":"insert",
        "table":"Wifi_Inet_Config",
        "row": {
            "if_name": "$CONFIG_RDK_BHAUL_AP_24_IFNAME",
            "if_type": "vif",
            "enabled": false,
            "dhcpd": ["map", [["start", "169.254.0.5"], ["stop", "169.254.0.253"]]]
       }
    },
    {
        "op":"insert",
        "table":"Wifi_Inet_Config",
        "row": {
            "if_name": "$CONFIG_RDK_BHAUL_AP_50_IFNAME",
            "if_type": "vif",
            "enabled": false,
            "dhcpd": ["map", [["start", "169.254.1.5"], ["stop", "169.254.1.253"]]]
       }
    },
    {
        "op":"insert",
        "table":"Wifi_Inet_Config",
        "row": {
            "if_name": "$CONFIG_RDK_LAN_ETH_IFNAME",
            "if_type": "eth",
            "enabled": true,
            "mac_reporting": true
       }
    }
]
EOF
