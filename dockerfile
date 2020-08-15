FROM linuxserver/remmina

# install openvpn
RUN apt-get update && \
    apt-get -y install openvpn && \
    echo "**** cleanup ****" && \
    apt-get clean && \
    rm -rf  /tmp/*  /var/lib/apt/lists/*  /var/tmp/*

CMD [ "/bin/bash", "-c", "cd /config && openvpn --config config.ovpn" ]