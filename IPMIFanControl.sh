# Supermicro X9 PID fan control systemd unit
[Unit]
Description=IPMI Fan Control
After=multi-user.target
 
[Service]
type=idle
ExecStart=/usr/bin/perl /usr/local/bin/IPMIFanControl.pl
 
[Install]
WantedBy=multi-user.target
