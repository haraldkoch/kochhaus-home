# Kochhaus Bind Deployment

At Kochhaus we do not like the various DNS options available on gateway routers
(typically a version of dnsmasq); they usually have limitations like no dynamic
updates, no zone files, or no DNSSEC.

Instead we run a pair of ISC-BIND nameservers, a primary and a secondary. Both
are also configured for recursive lookups, so they can be used by clients on the
Kochhaus networks.

Servers are configured to use these resolvers in a number of ways:

- servers on the primary server VLANs use these two resolvers directly.
- access devices (laptops, phones, tablets) and guest devices are configured to
  use Blocky, which is uses these resolvers as forwarders.
- devices on the iot network use Unbound on the router, and cannot see the
  internal DNS at all.

Most zones are configured for dynamic updates. The DHCP servers on the network
push zone updates to these two servers (using a TSIG key). `external-dns`
running on the Kubernetes clusters pushes updates, also using TSIG. For manual
updates, we have a small script that uses `nsupdate` to push changes.

## Primary Configuration

The named.conf.cluster file included here is commented to describe what the
various directives are used for.

A typical `zone` directive looks like:

```text
zone "home.arpa" IN {
        type primary;
        file "/var/lib/bind/home.arpa.zone";
        allow-update { key rndc-key; key dnsupdate; key dhcp; };
        allow-transfer { homelab; };
};
```

This stanza says that we are the/a primary server for `home.arpa`, that anyone
with one of the listed keys can perform dynamic updates, and that hosts in the
homelab acl can perform transfers. (Normally we would lock down transfers more
tightly, but this is a homelab).

NOTE: the default folder for zone files is `/var/cache/named` (this is configured in the `named.conf.options` file that is part of the `ubuntu/bind9` container image). We separate primary and secondary zone files, and store the primary zone files in a PVC, mounted at `/var/lib/bind`. To do this we must put the full pathname in the `file` directive.

Reverse zones are configured the same way.

We can add DNSSEC to this by adding:

```text
        key-directory "/etc/named/keys/chk.cfrq.net";
        dnssec-policy "default";
        inline-signing yes;
```

This enables DNSSEC with automatic signing after zone updates, and automated key
management (See below for details on DNSSEC and key generation).

## Secondary Configuration

A typical secondary zone configuration looks like:

```text
zone "home.arpa" IN {
    type secondary;
    file "home.arpa.zone";
    primaries { homelab; };
    allow-notify { homelab; };
};
```

This directs named to download a copy of the zone from one of the listed primary
servers, and store it locally (in /var/cache/bind, which is a PersistentVolume
to improve startup time).

When a primary nameserver updates a zone, it sends NOTIFY messages to all of the
nameservers listed in NS records for the zone, and to any servers listed in an
`also-notify` directive. By default, secondary nameservers will only accept
NOTIY mesasges from the configured primary nameservers.

In Kubernetes, the NOTIFY messages come from one of the Node IPs, not from the
configured service IP, so we need to add the `allow-notify` directive for these.
It's easiest just to use the homelab ACL for this, so we do.

## Recursion

## DHCP and Dynamic Updates

Our DHCP servers are configured to update the forward (addresses) and reverse
(PTR) zones automatically when a client requests an IP address. Each DHCP server
is configured with a TSIG key, and sends updates when a client first appears or
when its IP changes. (I do not believe that records are deleted when a lease
expires).

Kubernetes services are also published using dynamic updates and a different
TSIG key.

## Manual updates

When a zone is configured for dynamic updates, it is difficult to edit the
resulting zone file on disk. So to make manual updates to the DNS, we use a
small shell script that calls `nsupdate`.

## DNSSEC

todo
