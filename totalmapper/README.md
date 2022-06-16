# TotalMapper for Linux

1. Download release of TotalMapper from https://github.com/ellbur/totalmapper/releases
2. Test totalmapper as standalone application:
```
sleep 1; sudo totalmapper remap --layout-file /home/amolev/src/totalmapper.json --all-keyboards
```
3. Install totalmapper as service

```
sudo totalmapper add_systemd_service --layout-file /home/amolev/.dotfiles/totalmapper/totalmapper.json
```

4. Adjust configuration of systemd service

```
sudo vim /etc/systemd/system/totalmapper@.service
```

change `ExecStart` to:

```
ExecStart=/usr/bin/totalmapper remap --verbose --layout-file /etc/totalmapper.json --auto-all-keyboards --only-if-keyboard
```

5. Reload systemd

```
sudo systemctl daemon-reload
```

