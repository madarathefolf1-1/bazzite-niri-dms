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

# Ensure the system looks for custom global configs inside /etc
# Custom user defaults can be placed in /etc/skel/ to auto-populate on new accounts