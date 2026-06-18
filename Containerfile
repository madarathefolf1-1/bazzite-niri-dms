# Start from the exact upstream testing image for open-source NVIDIA modules
FROM ghcr.io/ublue-os/bazzite-nvidia-open:testing

# Combine repo configuration and installation into a single optimized layer
RUN dnf5 copr enable -y yorickmuralt/niri && \
    dnf5 copr enable -y avengemedia/dankmaterialshell && \
    dnf5 install -y \
    niri \
    DankMaterialShell \
    quickshell \
    matugen \
    network-manager-applet \
    pipewire-utils \
    wireplumber \
    xdg-desktop-portal \
    xdg-desktop-portal-wlr \
    xdg-desktop-portal-gnome \
    swaylock \
    swayidle \
    swaybg \
    cliphist \
    wl-clipboard \
    wtype \
    wlsunset \
    ghostty \
    && dnf5 clean all

# ---- AUTOMATED SIGNING TRUST ----
# This MUST happen after the workspace is checked out and right before the build finishes
COPY cosign.pub /usr/etc/pki/containers/bazzite-niri-dms.pub

RUN mkdir -p /usr/etc/containers/registries.d && \
    echo -e "docker:\n  ghcr.io/madarathefolf1-1/bazzite-niri-dms:\n    lookaside-verify-disabled: true\n    keypath: /usr/etc/pki/containers/bazzite-niri-dms.pub" > /usr/etc/containers/registries.d/bazzite-niri-dms.yaml