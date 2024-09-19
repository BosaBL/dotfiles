installPackage "sddm"

sudo cp -r "$SCRIPT_DIR"/assets/sddm-astronaut-theme /usr/share/sddm/themes
sudo cp "$SCRIPT_DIR"/assets/sddm.conf /etc/

sudo systemctl set-default graphical.target
sudo systemctl enable sddm.service
