# Linux

OpenTodoList is available for Linux in several formats. Choose the one that
fits your distribution and preferred update workflow.

<div class="download-badges" markdown>
<a href="https://flathub.org/apps/details/net.rpdev.OpenTodoList">
  <img alt="Download on Flathub" src="https://flathub.org/assets/badges/flathub-badge-en.png">
</a>
<a href="https://snapcraft.io/opentodolist">
  <img alt="Get it from the Snap Store" src="https://snapcraft.io/static/images/badges/en/snap-store-black.svg">
</a>
<a href="https://aur.archlinux.org/packages/opentodolist/">
  <img alt="Install from the AUR" src="../../../assets/AUR.svg">
</a>
</div>

## Supported Formats

- **Flathub:** Install from
  [Flathub](https://flathub.org/apps/details/net.rpdev.OpenTodoList) if your
  distribution supports Flatpak.
- **AppImage:** Download the AppImage from
  [GitHub Releases](https://github.com/mhoeher/opentodolist/releases) if you
  prefer a portable release artifact from the project.
- **Snap:** Install from [Snapcraft](https://snapcraft.io/opentodolist) if your
  distribution supports Snap packages.
- **AUR:** Install from the
  [AUR](https://aur.archlinux.org/packages/opentodolist/) if you use Arch Linux
  or an Arch-based distribution.

## First Run

After installation, open OpenTodoList and create a library. You can start with a
local library and add synchronization later.

Continue with [Getting Started](../../manual/getting-started.md).

## Wayland: Drag & Drop interaction issues

On Linux systems using Wayland, OpenTodoList may show reduced hover or
interaction behavior after performing drag & drop operations, for example when
reordering items. This can make the application appear unresponsive until
another click is performed.

### Workaround

As a workaround, OpenTodoList can be started using the X11 backend:

```bash
opentodolist -platform xcb
```

For AppImage builds:

```bash
./OpenTodoList.AppImage -platform xcb
```

This workaround restores the expected interaction behavior.
