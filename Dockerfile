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

# --- DAC (file permission) practice section ---

# Ek dusra user banao, aur ek shared group jisme dono ho
RUN groupadd labgroup && \
    useradd -m -s /bin/bash -G labgroup user2 && \
    echo "user2:password123" | chpasswd && \
    usermod -aG labgroup lowpriv

# Owner-only readable file (sirf lowpriv padh sakta hai)
RUN echo "Only lowpriv (owner) can read this" > /home/lowpriv/owner_only.txt && \
    chown lowpriv:lowpriv /home/lowpriv/owner_only.txt && \
    chmod 600 /home/lowpriv/owner_only.txt

# Group-readable file (lowpriv owner hai, labgroup wale padh sakte hain, others nahi)
RUN echo "lowpriv and anyone in labgroup can read this" > /home/lowpriv/group_read.txt && \
    chown lowpriv:labgroup /home/lowpriv/group_read.txt && \
    chmod 640 /home/lowpriv/group_read.txt

# World-readable file (koi bhi user padh sakta hai)
RUN echo "Everyone can read this" > /home/lowpriv/world_read.txt && \
    chown lowpriv:lowpriv /home/lowpriv/world_read.txt && \
    chmod 644 /home/lowpriv/world_read.txt

# No-permission file (owner khud bhi normal read nahi kar sakta)
RUN echo "Nobody can read this without root" > /home/lowpriv/no_perm.txt && \
    chown lowpriv:lowpriv /home/lowpriv/no_perm.txt && \
    chmod 000 /home/lowpriv/no_perm.txt

RUN chmod 755 /home/lowpriv

USER lowpriv
WORKDIR /home/lowpriv
CMD ["/bin/bash"]
