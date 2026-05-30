# Linux
## Wayland: Drag & Drop interaction issues

On Linux systems using Wayland, OpenTodoList may show reduced hover or interaction behavior after performing drag & drop operations (for example, reordering items). This can make the application appear unresponsive until another click is performed.

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
