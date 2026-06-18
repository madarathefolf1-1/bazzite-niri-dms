# Start from the exact upstream testing image for open-source NVIDIA modules
FROM ghcr.io/ublue-os/bazzite-nvidia-open:testing

# Combine repo configuration and installation into a single optimized layer
RUN dnf5 copr enable -y yalter/niri-git && \
    # 1. Download the repo file
    curl -Lo /etc/yum.repos.d/_copr_avengemedia-dankmaterialshell.repo \
    https://copr.fedorainfracloud.org/coprs/avengemedia/dankmaterialshell/repo/fedora-43/avengemedia-dankmaterialshell-fedora-43.repo && \
    # 2. Hardcode the release version to 43 so DNF5 doesn't auto-convert it to 44
    sed -i 's/\$releasever/43/g' /etc/yum.repos.d/_copr_avengemedia-dankmaterialshell.repo && \
    # 3. Force DNF to prefer the Git repository for Niri over native fallbacks
    echo "priority=1" >> /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:yalter:niri-git.repo && \
    # 4. Run the main package installation
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
COPY cosign.pub /usr/etc/pki/containers/bazzite-niri-dms.pub

RUN mkdir -p /usr/etc/containers/registries.d && \
    echo -e "docker:\n  ghcr.io/madarathefolf1-1/bazzite-niri-dms:\n    lookaside-verify-disabled: true\n    keypath: /usr/etc/pki/containers/bazzite-niri-dms.pub" > /usr/etc/containers/registries.d/bazzite-niri-dms.yaml