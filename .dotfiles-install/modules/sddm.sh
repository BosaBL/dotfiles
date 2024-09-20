installPackage "sddm"

sudo cp -r "$SCRIPT_DIR"/assets/sddm-astronaut-theme /usr/share/sddm/themes
sudo cp "$SCRIPT_DIR"/assets/sddm.conf /etc/

sudo chmod -R o+wrx /usr/share/sddm/themes/sddm-astronaut-theme

sudo systemctl set-default graphical.target
sudo systemctl enable sddm.service
