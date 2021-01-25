# mikrotik-admin-whitelist
Mikrotik Admin Whitelist

**Usage:**

Create /etc/mtadmin.lst (or specify a different file by changing the list= variable).  This file may contain hostnames, IPv4 and IPv6 addresses, or IPv4 and IPv6 CIDR blocks.  Basic sanity checks are in place but proper values fall solely on you.

Change the dudeservers= variable to the comma-separated IP addresses or hostnames of your Dude Servers.  Once your Dude Servers are added to a device, they will not be removed when the address list is purged and rewritten.  This will prevent Dude Server disconnects when the address list is updated.

Make the script executable and run.  Script will generate the file you specify by changing the file= value.

**Automation:**

It is recommended that you run the script with systemd timers:

```
printf '[Unit]
Description=Mikrotik Admin Whitelist Creator
[Service]
Type=simple
ExecStart=/usr/local/bin/mtadmin
[Install]
WantedBy=multi-user.target
' | sudo tee /etc/systemd/system/mtadmin.service

printf '[Unit]
Description=Mikrotik Admin Whitelist Scheduler
[Timer]
OnCalendar=*:0/5
Unit=mtadmin.service
[Install]
WantedBy=multi-user.target
' | sudo tee /etc/systemd/system/mtadmin.timer

systemctl enable mtadmin.timer
systemctl start mtadmin.timer
```

On each client device, use the scheduler to automatically download and import the whitelist as needed:

```
/system scheduler
add interval=5m name="adminwhitelist update" on-event="/tool fetch https://example.com/admin.rsc\
    \n/import admin.rsc" policy=read,write,test start-time=startup
```
