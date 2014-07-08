#! /bin/bash

# delete existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# block everything
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# ssh port 2020
iptables -A INPUT -p tcp -s 217.36.5.158 --dport 2020 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s 217.36.5.155 --dport 2020 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 2020 -j ACCEPT

# http
iptables -A INPUT -p tcp --sport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT

# https
iptables -A INPUT -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT

# smtp
# possibly setup smtps (http://www.cyberciti.biz/faq/howto-configure-sendmail-ssl-certificate-email/)
iptables -A INPUT -p tcp --dport 25 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 25 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 25 -j ACCEPT

# dns
iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --sport 53 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# prevent dos
iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT