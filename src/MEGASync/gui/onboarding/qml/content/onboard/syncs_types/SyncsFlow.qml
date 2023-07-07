// System
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

// QML common
import Common 1.0

// Local
import Onboard 1.0
import Onboard.Syncs_types.Left_panel 1.0
import Onboard.Syncs_types.Syncs 1.0
import Onboard.Syncs_types.Backups 1.0

// C++
import BackupsProxyModel 1.0

Rectangle {
    id: syncsPanel

    readonly property string computerName: "computerName"
    readonly property string syncType: "syncType"
    readonly property string syncs: "syncs"
    readonly property string selectiveSync: "selectiveSync"
    readonly property string fullSync: "fullSync"
    readonly property string backupsFlow: "backups"
    readonly property string finalState: "finalState"

    readonly property int stepPanelWidth: 304
    readonly property int contentMargin: 48
    readonly property int contentHeight: 464
    readonly property int lineWidth: 2

    property int typeSelected: SyncsType.Types.None

    color: Styles.surface1
    state: computerName
    states: [
        State {
            name: computerName
            StateChangeScript {
                script: rightPanel.replace(computerNamePage);
            }
            PropertyChanges {
                target: stepPanel;
                state: stepPanel.step1ComputerName;
            }
        },
        State {
            name: syncType
            StateChangeScript {
                script: rightPanel.replace(installationTypePage);
            }
            PropertyChanges {
                target: stepPanel;
                state: stepPanel.step2InstallationType;
            }
        },
        State {
            name: syncs
            StateChangeScript {
                script: rightPanel.replace(syncPage);
            }
            PropertyChanges {
                target: stepPanel;
                state: stepPanel.step3;
                step3Text: OnboardingStrings.syncChooseType;
                step4Text: OnboardingStrings.confirm;
            }
        },
        State {
            name: selectiveSync
            StateChangeScript {
                script: {
                    typeSelected = SyncsType.Types.SelectiveSync;
                    rightPanel.replace(selectiveSyncPage);
                }
            }
            PropertyChanges {
                target: stepPanel;
                state: stepPanel.step4;
                step3Text: OnboardingStrings.syncChooseType;
                step4Text: OnboardingStrings.selectiveSync;
            }
        },
        State {
            name: fullSync
            StateChangeScript {
                script: {
                    typeSelected = SyncsType.Types.FullSync;
                    rightPanel.replace(fullSyncPage);
                }
            }
            PropertyChanges {
                target: stepPanel;
                state: stepPanel.step4;
                step3Text: OnboardingStrings.syncChooseType;
                step4Text: OnboardingStrings.fullSync;
            }
        },
        State {
            name: backupsFlow
            StateChangeScript {
                script: {
                    typeSelected = SyncsType.Types.Backup;
                    rightPanel.replace(backupsFlowPage);
                }
            }
            PropertyChanges {
                target: stepPanel;
                state: stepPanel.step3;
                step3Text: OnboardingStrings.backupSelectFolders;
                step4Text: OnboardingStrings.backupConfirm;
            }
        },
        State {
            name: finalState
            StateChangeScript {
                script: rightPanel.replace(finalPage);
            }
            PropertyChanges {
                target: stepPanel;
                state: stepPanel.stepAllDone;
                step3Text: typeSelected === SyncsType.Types.Backup
                           ? OnboardingStrings.backupSelectFolders
                           : OnboardingStrings.syncChooseType;
                step4Text: typeSelected === SyncsType.Types.Backup
                           ? OnboardingStrings.backupConfirm
                           : OnboardingStrings.syncSetUp;
            }
        }
    ]

    Rectangle {
        id: leftPanel

        width: stepPanelWidth + lineWidth
        height: parent.height
        color: Styles.surface1
        z: 2

        StepPanel {
            id: stepPanel

            anchors.fill: parent
            anchors.topMargin: contentMargin
            anchors.bottomMargin: contentMargin
            anchors.leftMargin: contentMargin
        }

        Rectangle {
            id: separatorLine

            width: lineWidth
            radius: lineWidth
            color: Styles.borderDisabled
            height: contentHeight
            anchors.left: leftPanel.right
            anchors.top: parent.top
            anchors.topMargin: contentMargin
        }
    }

    StackView {
        id: rightPanel

        anchors {
            left: leftPanel.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: contentMargin
        }

        Component {
            id: computerNamePage

            ComputerNamePage {}
        }

        Component {
            id: installationTypePage

            InstallationTypePage {}
        }

        Component {
            id: syncPage

            SyncTypePage {}
        }

        Component {
            id: fullSyncPage

            FullSyncPage {}
        }

        Component {
            id: selectiveSyncPage

            SelectiveSyncPage {}
        }

        Component{
            id: backupsFlowPage

            BackupsFlow {}
        }

        Component {
            id: finalPage

            ResumePage {}
        }
    }
}
