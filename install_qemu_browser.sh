#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

echo "Updating TinyCore package database..."
tce-load -wi compiletc curl git wget

echo "Installing QEMU and dependencies..."
tce-load -wi qemu gtk2 glib2 libvirt vde2

echo "Installing TinyCore AppBrowser..."
tce-load -wi ab

echo "Installing a lightweight web browser (Falkon)..."
tce-load -wi falkon qt5

echo "Installing JWM (Windows XP-like desktop)..."
tce-load -wi jwm

echo "Creating QEMU desktop shortcut..."
mkdir -p /usr/local/share/applications
cat <<EOF > /usr/local/share/applications/qemu.desktop
[Desktop Entry]
Name=QEMU
Exec=qemu-system-x86_64
Icon=qemu
Type=Application
Categories=System;Emulator;
EOF

echo "Creating Web Browser desktop shortcut..."
cat <<EOF > /usr/local/share/applications/falkon.desktop
[Desktop Entry]
Name=Falkon Web Browser
Exec=falkon
Icon=web-browser
Type=Application
Categories=Network;WebBrowser;
EOF

# Modify JWM to look like Windows XP
echo "Configuring JWM for Windows XP look..."
mkdir -p ~/.jwm
cat <<EOF > ~/.jwmrc
<JWM>
    <StartupCommand>xsetroot -solid black</StartupCommand>
    <RootMenu height="20" onroot="3">
        <Program icon="filemanager" label="File Manager">pcmanfm</Program>
        <Program icon="terminal" label="Terminal">aterm</Program>
        <Program icon="browser" label="Falkon Browser">falkon</Program>
        <Program icon="qemu" label="QEMU Emulator">qemu-system-x86_64</Program>
        <Exit label="Logout" confirm="true"/>
    </RootMenu>

    <Tray x="0" y="-1" height="26" autohide="false" bgcolor="#d4d0c8" >
        <TrayButton label="Start" icon="mini-xterm.xpm">root:3</TrayButton>
        <TaskList maxwidth="256"/>
        <Clock format="%H:%M">xclock</Clock>
    </Tray>
</JWM>
EOF

# Ensuring execution permissions
chmod +x /usr/local/share/applications/qemu.desktop
chmod +x /usr/local/share/applications/falkon.desktop

echo "Creating symlink for easier QEMU access..."
ln -s /usr/local/bin/qemu-system-x86_64 /usr/bin/qemu

echo "Fetching OSX and Windows dependencies..."
tce-load -wi seabios ovmf

echo "Setup complete! Restart JWM for the Windows XP look."
echo "Use right-click on the desktop for the Start Menu."
