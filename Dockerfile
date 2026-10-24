# ==============================================================================
# AeroGaming OS - Containerized ISO Build Environment
# Builds bootable hybrid UEFI/BIOS ISO in a clean Debian Bookworm container
# ==============================================================================

FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install live-build toolchain and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    live-build \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-utils \
    mtools \
    dosfstools \
    grub-pc-bin \
    grub-efi-amd64-bin \
    rsync \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Copy build tree
COPY . /workspace

# Set execution bits
RUN chmod +x /workspace/scripts/*.sh \
    /workspace/live-build/auto/config \
    /workspace/live-build/config/hooks/normal/*.hook.chroot 2>/dev/null || true

# Entrypoint runs the build
CMD ["/bin/bash", "/workspace/scripts/build-iso.sh"]

