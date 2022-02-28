FROM archlinux

COPY public.pgp /tmp/public.pgp

# Sort mirrors by speed and add PGP keys
RUN pacman --sync --refresh --noconfirm \
        reflector \
    && reflector \
        --country CA \
        --save /etc/pacman.d/mirrorlist \
        --protocol https \
        --latest 20 \
        --sort rate \
    && pacman-key --init \
    && pacman-key --add /tmp/public.pgp \
    && pacman-key --lsign-key 9DADB840E2DB03888C3EBB3052676D3D2207F7EB \
    && /bin/rm /tmp/public.pgp \
    && /bin/rm -rf /var/cache/pacman/pkg

# add local repo
RUN echo $'\n\
[kochhaus]\n\
SigLevel = Required\n\
Server = https://penelope.cfrq.net/arch/kochhaus/$arch' >> /etc/pacman.conf

# inet-utils for /bin/hostname
RUN yes | pacman --sync --refresh \
        ansible \
        curl \
        diffutils \
        flux-bin \
        git \
        inetutils \
        helm \
        kubectl \
        kustomize \
        rsync \
    && /bin/rm -rf /var/cache/pacman/pkg
