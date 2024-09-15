packageInstall "sddm"

sudo cp -r sddm-astronaut-theme /usr/share/sddm/themes
sudo cp -i ./sddm.conf /etc/

sudo systemctl set-default graphical.target
sudo systemctl enable sddm.service
