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
            "if_name": "$CONFIG_RDK_BHAUL_24_IFNAME",
            "if_type": "vif",
            "enabled": false,
            "dhcpd": ["map", [["start", "169.254.0.5"], ["stop", "169.254.0.253"]]]
       }
    },
    {
        "op":"insert",
        "table":"Wifi_Inet_Config",
        "row": {
            "if_name": "$CONFIG_RDK_BHAUL_50_IFNAME",
            "if_type": "vif",
            "enabled": false,
            "dhcpd": ["map", [["start", "169.254.1.5"], ["stop", "169.254.1.253"]]]
       }
    }
]
EOF
