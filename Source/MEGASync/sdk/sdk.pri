SOURCES += $$PWD/src/attrmap.cpp \
    $$PWD/src/backofftimer.cpp \
    $$PWD/src/base64.cpp \
    $$PWD/src/command.cpp \
    $$PWD/src/commands.cpp \
    $$PWD/src/db.cpp \
    $$PWD/src/gfx.cpp \
    $$PWD/src/file.cpp \
    $$PWD/src/fileattributefetch.cpp \
    $$PWD/src/filefingerprint.cpp \
    $$PWD/src/filesystem.cpp \
    $$PWD/src/http.cpp \
    $$PWD/src/json.cpp \
    $$PWD/src/megaclient.cpp \
    $$PWD/src/node.cpp \
    $$PWD/src/pubkeyaction.cpp \
    $$PWD/src/request.cpp \
    $$PWD/src/serialize64.cpp \
    $$PWD/src/share.cpp \
    $$PWD/src/sharenodekeys.cpp \
    $$PWD/src/sync.cpp \
    $$PWD/src/transfer.cpp \
    $$PWD/src/transferslot.cpp \
    $$PWD/src/treeproc.cpp \
    $$PWD/src/user.cpp \
    $$PWD/src/utils.cpp \
    $$PWD/src/waiter.cpp  \
    $$PWD/src/crypto/cryptopp.cpp  \
    $$PWD/src/db/sqlite.cpp  \
    $$PWD/src/gfx/qt.cpp \
    $$PWD/megaapi.cpp \
    $$PWD/qt/QTMegaRequestListener.cpp \
    $$PWD/qt/QTMegaTransferListener.cpp \
    $$PWD/qt/QTMegaListener.cpp \
    $$PWD/MegaProxySettings.cpp

win32 {
SOURCES += $$PWD/src/win32/net.cpp  \
    $$PWD/src/win32/fs.cpp  \
    $$PWD/src/win32/winwaiter.cpp  \
    $$PWD/win32/megaapiwait.cpp \
    $$PWD/win32/megaapiwinhttpio.cpp
}

unix {
SOURCES += $$PWD/src/posix/net.cpp  \
    $$PWD/src/posix/fs.cpp  \
    $$PWD/src/posix/posixwaiter.cpp \
    $$PWD/linux/megaapiwait.cpp \
    $$PWD/linux/megaapiposixhttpio.cpp
}

HEADERS  += $$PWD/include/mega.h \
	    $$PWD/include/mega/account.h \
	    $$PWD/include/mega/attrmap.h \
	    $$PWD/include/mega/backofftimer.h \
	    $$PWD/include/mega/base64.h \
	    $$PWD/include/mega/command.h \
	    $$PWD/include/mega/console.h \
	    $$PWD/include/mega/db.h \
	    $$PWD/include/mega/gfx.h \
	    $$PWD/include/mega/file.h \
	    $$PWD/include/mega/fileattributefetch.h \
	    $$PWD/include/mega/filefingerprint.h \
	    $$PWD/include/mega/filesystem.h \
	    $$PWD/include/mega/http.h \
	    $$PWD/include/mega/json.h \
	    $$PWD/include/mega/megaapp.h \
	    $$PWD/include/mega/megaclient.h \
	    $$PWD/include/mega/node.h \
	    $$PWD/include/mega/pubkeyaction.h \
	    $$PWD/include/mega/request.h \
	    $$PWD/include/mega/serialize64.h \
	    $$PWD/include/mega/share.h \
	    $$PWD/include/mega/sharenodekeys.h \
	    $$PWD/include/mega/sync.h \
	    $$PWD/include/mega/transfer.h \
	    $$PWD/include/mega/transferslot.h \
	    $$PWD/include/mega/treeproc.h \
	    $$PWD/include/mega/types.h \
	    $$PWD/include/mega/user.h \
	    $$PWD/include/mega/utils.h \
	    $$PWD/include/mega/waiter.h \
	    $$PWD/include/mega/crypto/cryptopp.h  \
	    $$PWD/include/mega/db/sqlite.h  \
	    $$PWD/include/mega/gfx/qt.h \
	    $$PWD/megaapi.h \
	    $$PWD/qt/QTMegaRequestListener.h \
	    $$PWD/qt/QTMegaTransferListener.h \
	    $$PWD/qt/QTMegaListener.h \
	    $$PWD/MegaProxySettings.h

win32 {
    HEADERS  += $$PWD/include/mega/win32/meganet.h  \
            $$PWD/include/mega/win32/megasys.h  \
            $$PWD/include/mega/win32/megafs.h  \
            $$PWD/include/mega/win32/megawaiter.h  \
	    $$PWD/win32/megaapiwait.h \
	    $$PWD/win32/megaapiwinhttpio.h

    SOURCES += $$PWD/sqlite3.c
}


unix:!macx {
    HEADERS  += $$PWD/include/mega/posix/meganet.h  \
            $$PWD/include/mega/posix/megasys.h  \
            $$PWD/include/mega/posix/megafs.h  \
            $$PWD/include/mega/posix/megawaiter.h \
            $$PWD/include/mega/linux/megaapiwait.h  \
            $$PWD/include/mega/config.h \
	    $$PWD/win32/megaapiwinhttpio.h
}

DEFINES += USE_SQLITE USE_CRYPTOPP USE_QT
LIBS += -lcryptopp
INCLUDEPATH += $$PWD/include

!release {
    DEFINES += SQLITE_DEBUG
}

INCLUDEPATH += $$PWD
INCLUDEPATH += $$PWD/3rdparty/include

win32 {

    INCLUDEPATH += $$PWD/include/mega/win32
    INCLUDEPATH += $$PWD/3rdparty/include/cryptopp

    contains(CONFIG, BUILDX64) {
	release {
	    LIBS += -L"$$_PRO_FILE_PWD_/sdk/3rdparty/libs/static_x64"
	}
	else {
	    LIBS += -L"$$_PRO_FILE_PWD_/sdk/3rdparty/libs/staticd_x64"
	}
    }

    !contains(CONFIG, BUILDX64) {
	release {
	    LIBS += -L"$$_PRO_FILE_PWD_/sdk/3rdparty/libs/static"
	}
	else {
	    LIBS += -L"$$_PRO_FILE_PWD_/sdk/3rdparty/libs/staticd"
	}
    }

    LIBS += -lwinhttp -lws2_32 -luser32
}

unix:!macx {
   INCLUDEPATH += $$PWD/include
   INCLUDEPATH += $$PWD/include/mega/posix
   INCLUDEPATH += /usr/include/cryptopp

   LIBS += -lsqlite3 -lrt

   exists($$PWD/3rdparty/libs/libcurl.a) {
    INCLUDEPATH += $$PWD/3rdparty/include/curl
    LIBS += -L$$PWD/3rdparty/libs/ $$PWD/3rdparty/libs/libcurl.a -lz -lssl -lcrypto -lcares
   }
   else {
    LIBS += -lcurl
   }
}

macx {
   INCLUDEPATH += $$PWD/include
   INCLUDEPATH += $$PWD/include/mega/posix
   INCLUDEPATH += $$PWD/3rdparty/include/cryptopp

   LIBS += -lsqlite3

   INCLUDEPATH += $$PWD/3rdparty/include/curl
   LIBS += -L$$PWD/3rdparty/libs/ $$PWD/3rdparty/libs/libcares.a $$PWD/3rdparty/libs/libcurl.a -lz -lssl -lcrypto
}
