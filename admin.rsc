--Example admin.rsc file generated by the script--

# Generated on Fri Jun 01 00:00:00 UTC 2019
:log info "Importing Admin Address List"
/system logging disable 0
/ip firewall address-list
/ip firewall address-list remove [find list=admin comment!=dude]
:if ([:ip firewall address-list find list=admin address=1.1.1.2] = "") do={
 :ip firewall address-list add list=admin address=1.1.1.2 comment=dude timeout=1d} else={
  :if ([:ip firewall address-list find list=admin address=1.1.1.2] != "") do={
   :ip firewall address-list set [:ip firewall address-list find list=admin address=1.1.1.2] timeout=1d}} on-error={}
/do {ip firewall address-list add list=admin address=1.1.1.1 timeout=4h} on-error={}
/do {ip firewall address-list add list=admin address=1.1.1.0/29 timeout=4h} on-error={}
/do {ip firewall filter set [:ip firewall filter find dst-port="22"] src-address-list=admin} on-error={}
/do {ip firewall filter set [:ip firewall filter find dst-port="80"] src-address-list=admin} on-error={}
/do {ip firewall filter set [:ip firewall filter find dst-port="443"] src-address-list=admin} on-error={}
/do {ip firewall filter set [:ip firewall filter find dst-port="8291"] src-address-list=admin} on-error={}
:if ([:system package find name=ipv6 disabled=yes] = "") do={
 /ipv6 firewall address-list
 /ipv6 firewall address-list remove [find list=admin comment!=dude]
 :if ([:ipv6 firewall address-list find list=admin address=2001:0db8:85a3:0000:0000:8a2e:0370:7335] = "") do={
  :ipv6 firewall address-list add list=admin address=2001:0db8:85a3:0000:0000:8a2e:0370:7335 comment=dude timeout=1d} else={
   :if ([:ipv6 firewall address-list find list=admin address=2001:0db8:85a3:0000:0000:8a2e:0370:7335] != "") do={
    :ipv6 firewall address-list set [:ipv6 firewall address-list find list=admin address=2001:0db8:85a3:0000:0000:8a2e:0370:7335] timeout=1d}} on-error={}
 /do {ipv6 firewall address-list add list=admin address=2001:0db8:85a3:0000:0000:8a2e:0370:7334 timeout=4h} on-error={}
 /do {ipv6 firewall address-list add list=admin address=2001:db8:1a:3000::/60 timeout=4h} on-error={}
 /do {ipv6 firewall filter set [:ipv6 firewall filter find dst-port="22"] src-address-list=admin} on-error={}
 /do {ipv6 firewall filter set [:ipv6 firewall filter find dst-port="80"] src-address-list=admin} on-error={}
 /do {ipv6 firewall filter set [:ipv6 firewall filter find dst-port="443"] src-address-list=admin} on-error={}
 /do {ipv6 firewall filter set [:ipv6 firewall filter find dst-port="8291"] src-address-list=admin} on-error={}
}
/system logging enable 0
:log info "Admin Address List Import Complete"
:if ([:system scheduler find name="adminwhitelist update"] = "") do={
 :system scheduler add interval=5m name="adminwhitelist update" on-event="/tool fetch \
  https://www.example.com/admin.rsc\
  \n/import admin.rsc" policy=read,write,test start-time=startup}
:if ([:system scheduler find name="whitelist failsafe"] = "") do={
 :system scheduler add interval=72h name="whitelist failsafe" on-event="\
  do {:ip firewall address-list add list=admin address=0.0.0.0/0}
  :if ([:system package find name=ipv6 disabled=yes] = \"\") do={
   :ipv6 firewall address-list add list=admin address=::/0}"} else={
:if ([:system scheduler find name="whitelist failsafe"] != "") do={
 :system scheduler set [:system scheduler find name="whitelist failsafe"] interval=72h\
  start-date=Jun/01/2019 start-time=00:00:00}}
