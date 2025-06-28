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

``` text 
default.clock.allowed-rates = [ 44100, 48000, 88200, 96000, 176400, 192000, 352800, 384000 ]
``` 

> [!IMPORTANT]
> If you installing `WiFi` module on your system, you should connect to your network before going to installing software step.

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

for support other streaming service, library and playback software.

- Roon
- Qoobuz
- Tidal
- Deezer
- HQplayer
- ytmdesktop