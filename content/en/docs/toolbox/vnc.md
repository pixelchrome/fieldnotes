---
linkTitle: "VNC"
weight: 260
---

# TigerVNC

Install TigerVNC and XFCE on a remote server - tunnel VNC via SSH

https://community.hetzner.com/tutorials/install-tigervnc

## Introduction

TigerVNC is an open-source VNC (Virtual Network Computing) software, that allows users to use graphical applications on servers.

### Prerequisites

A server running Ubuntu 18.04 (tested)
Step 1 - Installing packages

The easiest way of installing TigerVNC on a new system is by using the apt repository.

$ sudo apt update
$ sudo apt upgrade

### Install virtual window manager, terminal emulator, xfce and tigervnc
$ sudo apt install fvwm xterm xfce4 xfce4-goodies gnome-session tigervnc-standalone-server tigervnc-common
Step 2 - Configure and start the VNC server

Step 2.1 - Start and kill the VNC server

To start the server you can run the following command:

$ vncserver
On the first start you must enter a VNC password.

To kill VNC instances run the following commands:

### Kill all running VNC instances
$ vncserver -kill :*

### Kill only one instance by id
$ vncserver -kill :<id>
To list all running instances you can run the following command:

$ vncserver -list
Step 2.2 - Configure the VNC server

You can create a configuration file at ~/.vnc/xstartup.

### Create the startup file
$ touch ~/.vnc/xstartup

### Set the file permission
$ chmod 700 ~/.vnc/xstartup

### Edit the file
$ vi ~/.vnc/xstartup
An example configuration for xfce4:

#!/bin/sh
xrdb $HOME/.Xresources
startxfce4 &
Step 2.3 - Complete configuration

Finish the configuration by starting the server:

$ vncserver
Step 3 - Connect to VNC

To connect from your local computer to the VNC server first open an SSH tunnel to the server:

$ ssh holu@10.0.0.1 -L 5901:127.0.0.1:5901 -N
After this you can use a VNC client to connect to the server with the address 127.0.0.1.

Conclusion

You are now ready to access your server via VNC (for example by using the vncviewer client provided by TigerVNC).

## Remarks

If you want to run Application from the terminal window, it might be necessary to use ***xhost +***