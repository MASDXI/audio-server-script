# audio-server-script  

A Linux setup script for high-fidelity, headless audio playback. Optimized for bit-perfect output via `PipeWire`, with support for `Audirvana`, and `Spotify`.

## Preparing operating system configuration

Set current user allow to `NOPASSWD`

``` shell
sudo visudo
```

Add this line to the configuration.
``` text
$USER ALL=(ALL) NOPASSWD:ALL
```

Delete password form current user.
``` shela
sudo passwd -d $USER
```

Priority `audio` process by config `/etc/security/limits.d/audio.con`

Add this line for allowing `audio` process priority to `95` and allow using memory `unlimited`.
``` text
@audio   -  rtprio     95
@audio   -  memlock    unlimited
```

Add current user to `audio`, if `audio` group not exist it's will create.

```
getent group audio || sudo groupadd audio && sudo usermod -aG audio $USER
```

Change `/usr/share/pipewire/pirewire.conf`, let `pipewire` change clock rates to avoid unintended upsampling/resampling.  

``` shell
mkdir -p .config/pipewire
```

Copy `pipewire.conf` to `.config/pipewire`

``` shell
sudo cp /usr/share/pipewire/pipewire.conf .config/pirewire
```

Edit uncomment `default.clock.allowed-rates` line.

``` text 
default.clock.allowed-rates = [ 44100, 48000, 88200, 96000, 176400, 192000, 352800, 384000, 705600, 76800, 1311200, 1536000 ]
``` 

Copy `client.conf` and `pipewire-pulse.conf` to `.config/pipewire`

``` shell
sudo cp /usr/share/pipewire/client.conf .config/pirewire
sudo cp /usr/share/pipewire/pipewire-pulse.conf .config/pirewire
```

Edit uncomment `resample.quality` and add `resample.disable` to both file

``` text
resample.disable = true
resample.quality = 0
``` 

Restart the `pipewire` service.

``` shell
systemctl --user restart pipewire.service pipewire-pulse.service
```

Disable power-off confirmation for convenience use in headless setup.

``` shell
gsettings set org.gnome.SessionManager logout-prompt false
```

Disable GUI visual-effect.

``` shell
gsettings set org.gnome.desktop.interface enable-animations false
```

Disable System sound.

``` shell
gsettings set org.gnome.desktop.sound event-sounds false
```

> [!IMPORTANT]
> If you installing `WiFi` module e.g., pci-e, usb dongle on your system, you should connect to your network before going to installing software step.

## Installing streaming service software

To install `audirvana` using command:
``` shell
./audirvana-setup.sh
```

<!-- TODO -->
<!-- To install `roon` using command:
``` shell
./roon-setup.sh
``` -->

To install `spotify` using command:
``` shell
./spotifyd-setup.sh
```

> [!NOTE]
> The `hostname` use as default device name of `audirvana` and `spotify`.

## TODO 

Considered to support other streaming service, library and playback software.

`electron` wrapped application
- `apple-music-desktop` for Apple Music
- `deezer-linux` for Deezer
- `qobuz-linux` for Qobuz
- `tidal-hifi` for Tidal
- `ytmdesktop` for Youtube Music
