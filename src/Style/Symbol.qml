import QtQuick


/*
  A clickable symbol.

  A Symbol is based on a toolbutton, but without any background. Instead, it
  uses the button color to indicate it is interactive.
  */
ToolButton {

    flat: true
    textColor: palette.button
}
