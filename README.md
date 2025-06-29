# audio-server-script  

## Preparing operating system configuration

Set current user allow to `NOPASSWD`

``` shell
$ sudo visudo
```

Add this line to the configuration
``` text
USER ALL=(ALL) NOPASSWD:ALL
```

Delete password form current user
``` shell
$ sudo passwd -d USER
```

Priority audio process by config `/etc/security/limits.d/audio.con`

Add this line for allowing audio process priority to `95` and allow using memory `unlimited`.
``` text
@audio   -  rtprio     95
@audio   -  memlock    unlimited
```

> [!TIP]
> using command `whoami` for get current user


Change `/usr/share/pipewire/pirewire.conf`, let `pipewire` change clock rates to avoid unintended upsampling.  

``` shell
$ mkdir -p .config/pipewire
```

Copy `pipewire.conf` to `.config/pipewire`
``` shell
$ sudo cp /usr/share/pipewire/pirewire.conf .config/pirewire/
```

Edit uncomment `default.clock.allowed-rates` line

``` text 
default.clock.allowed-rates = [ 44100, 48000, 88200, 96000, 176400, 192000, 352800, 384000 ]
``` 

Restart `pipewire` 

``` shell
$ systemctl --user restart pipewire.service pipewire-pulse.service
```

Disable power-off confirmation for convenience use in headless setup.

``` shell
$ gsettings set org.gnome.SessionManager logout-prompt false
```

> [!IMPORTANT]
> If you installing `WiFi` module e.g., pci-e, usb dongle on your system, you should connect to your network before going to installing software step.

## Installing streaming service software

To install `audirvana` using command:
``` shell
$ ./audirvana-setup.sh
```

To install `spotify` using command:
``` shell
$ ./spotifyd-setup.sh
```

> [!NOTE]
> The `hostname` use as default device name of `audirvana` and `spotify`.

## TODO 

To support other streaming service, library and playback software.

- some DLNA/uPNP setup for cast
- Automatic Ripping Machine (ARM)
- DeaDBeef
- Clementine
- Foobar2000
- HQplayer
- Roon

No official linux support
- Deezer deezer-linux
- Qobuz qobuz-linux
- Tiodal tidal-hifi
- Youtube Music ytmdesktop