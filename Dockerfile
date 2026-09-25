
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    sudo vim nano bash coreutils findutils \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash lowpriv && \
    echo "lowpriv:password123" | chpasswd

RUN mkdir -p /root/secrets && \
    echo "FLAG{root_access_achieved}" > /root/secrets/flag.txt && \
    chmod 600 /root/secrets/flag.txt

RUN echo '#!/bin/bash' > /usr/local/bin/rootcron.sh && \
    echo 'echo "cron ran" >> /tmp/cronlog' >> /usr/local/bin/rootcron.sh && \
    chmod 777 /usr/local/bin/rootcron.sh

RUN cp /bin/cp /usr/local/bin/vulncp && \
    chmod u+s /usr/local/bin/vulncp

RUN echo "lowpriv ALL=(root) NOPASSWD: /usr/bin/find" >> /etc/sudoers

RUN touch /etc/custom.conf && chmod 666 /etc/custom.conf

USER lowpriv
WORKDIR /home/lowpriv
CMD ["/bin/bash"]

