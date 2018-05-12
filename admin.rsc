--Example admin.rsc file generated by the script--

# Generated on Mon Jan  1 00:00:00 UTC 1970
:log info "Importing Admin Address List"
/system logging disable 0
/ip firewall address-list
/ip firewall address-list remove [find list=admin !address=1.1.1.2]
:if ([:ip firewall address-list find list=admin address=1.1.1.2] = "") do={
 ip firewall address-list add list=admin address=1.1.1.2}
/do {ip firewall address-list add list="admin" address=1.1.1.1} on-error={}
/do {ip firewall address-list add list="admin" address=1.1.1.0/29} on-error={}
/ip firewall filter set [ :ip firewall filter find dst-port="22" ] src-address-list=admin
/ip firewall filter set [ :ip firewall filter find dst-port="80" ] src-address-list=admin
/ip firewall filter set [ :ip firewall filter find dst-port="443" ] src-address-list=admin
/ip firewall filter set [ :ip firewall filter find dst-port="8291" ] src-address-list=admin
:if ([/system package find name=ipv6 disabled=yes] = "") do={
 /ipv6 firewall address-list
 /ipv6 firewall address-list remove [find list=admin !address=2001:0db8:85a3:0000:0000:8a2e:0370:7335]
 :if ([:ipv6 firewall address-list find list=admin address=2001:0db8:85a3:0000:0000:8a2e:0370:7335] = "") do={
 ipv6 firewall address-list add list=admin address=2001:0db8:85a3:0000:0000:8a2e:0370:7335}
 /do {ipv6 firewall address-list add list="admin" address=2001:0db8:85a3:0000:0000:8a2e:0370:7334} on-error={}
 /do {ipv6 firewall address-list add list="admin" address=2001:db8:1a:3000::/60} on-error={}
 /ipv6 firewall filter set [ :ipv6 firewall filter find dst-port="22" ] src-address-list=admin
 /ipv6 firewall filter set [ :ipv6 firewall filter find dst-port="80" ] src-address-list=admin
 /ipv6 firewall filter set [ :ipv6 firewall filter find dst-port="443" ] src-address-list=admin
 /ipv6 firewall filter set [ :ipv6 firewall filter find dst-port="8291" ] src-address-list=admin
}
/system logging enable 0
:log info "Admin Address List Import Complete"
