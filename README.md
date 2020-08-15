# Remmina & OpenVPN inside Docker Container

This dockerfile makes possible to connect to a RDP through VPN and access the RDP client throught your web browser.

It extends the [linuxserver/remmina](https://hub.docker.com/r/linuxserver/remmina/) image with OpenVPN.


## Docker configuration

You need a `config` directory on your host system, that will be mounted to the container. 
This directory will be used for Remmina configurations. 
It should also contain the OpenVPN configuration file called `config.ovpn`.

### Remmina RDP
For detailed Remmina RDP configurations see [linuxserver/remmina](https://hub.docker.com/r/linuxserver/remmina/).

### OpenVPN
For OpenVPN you have to use following arguments:


| Argument | Description |
|-|-|
| --dns-search="domain" | Domain of the dns server |
| --dns="dns-ip" | ip of the dns server (use multiple attributes for multiple ips) |
| --cap-add=NET_ADMIN | Give privileged access to host devices |
| --device /dev/net/tun | Import tun device to allow OpenVPN create a tunnel |

Unfortunately it is not possible to set the dns inside the container dynamically (`/etc/resolv.conf`), 
because docker sets that according to the given arguments. So OpenVPN can't set them automatically.
Therefore you need to find out yourself, the correct dns ips and set them while starting/creating the container.



## Example

In this example we will create a docker container and start it with port 3000.

After starting the container, you can access Remmina RDP in your browser at [localhost:3000](http://localhost:3000).

### Prepare

Create a config folder e.g. `/home/user/remmina/config`.

Add the OpenVPN configuration to this folder, and call that `config.ovpn`.

If you have to use `auth-user-pass` you can add your user and password in a file, and reference that inside your `config.ovpn` like that: `auth-user-pass ./login.conf`

### Create and start docker container

**Create docker image**
```
docker build ./ --tag rdp
```

**Create**
```
docker create \
  --name=rdp \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -p 3000:3000 \
  -v /home/user/remmina/config:/config \
  --restart unless-stopped \
  --dns-search=vpn-domain.com \
  --dns=10.200.6.1 \
  --dns=10.200.6.2 \
  --cap-add=NET_ADMIN --device /dev/net/tun \
  rdp
```

**Start**
```
docker start rdp
```



