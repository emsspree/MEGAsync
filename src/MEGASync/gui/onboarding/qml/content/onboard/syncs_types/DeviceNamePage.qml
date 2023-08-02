import QtQml 2.12

//Local
import Onboard 1.0
import QmlDeviceName 1.0

DeviceNamePageForm {

    footerButtons.rightPrimary.onClicked: {
        if(!deviceName.setDeviceName(deviceNameTextField.text)) {
            syncsPanel.state = syncType;
            return;
        }
    }

    QmlDeviceName {
        id: deviceName

        onDeviceNameSet: {
            syncsPanel.state = syncType;
        }
    }
}

