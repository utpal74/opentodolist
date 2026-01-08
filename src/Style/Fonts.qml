pragma Singleton

import QtQuick

Item {
    property alias iconFont: materialDesignIcons.name
    property alias titleFont: comfortaa.name
    property alias regularFont: oxygenRegular.name
    property alias lightFont: oxygenLight.name
    property alias boldFont: oxygenBold.name
    property alias monoFont: oxygenMono.name

    FontLoader {
        id: materialDesignIcons
        source: "./material-design-icons/font/MaterialIconsOutlined-Regular.otf"
    }

    FontLoader {
        id: comfortaa
        source: "./Comfortaa/Comfortaa-VariableFont_wght.ttf"
    }

    FontLoader {
        id: oxygenRegular
        source: "./Oxygen/Oxygen-Regular.ttf"
    }

    FontLoader {
        id: oxygenLight
        source: "./Oxygen/Oxygen-Light.ttf"
    }

    FontLoader {
        id: oxygenBold
        source: "./Oxygen/Oxygen-Bold.ttf"
    }

    FontLoader {
        id: oxygenMono
        source: "./Oxygen/OxygenMono-Regular.ttf"
    }
}
