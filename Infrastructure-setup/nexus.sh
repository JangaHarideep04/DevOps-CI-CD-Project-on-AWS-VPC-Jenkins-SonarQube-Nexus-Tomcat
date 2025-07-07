cd $INSTALL_DIR
sudo wget https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz
sudo tar -zxvf nexus-${NEXUS_VERSION}-unix.tar.gz
sudo mv nexus-${NEXUS_VERSION} nexus

# Set permissions
sudo chown -R $NEXUS_USER:$NEXUS_USER $NEXUS_DIR
sudo chown -R $NEXUS_USER:$NEXUS_USER $SONATYPE_DIR

# Configure Nexus to run as nexus user
echo "run_as_user=${NEXUS_USER}" | sudo tee $NEXUS_DIR/bin/nexus.rc

# Create systemd service
sudo tee /etc/systemd/system/nexus.service > /dev/null <<EOL
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=${NEXUS_USER}
Group=${NEXUS_USER}
ExecStart=${NEXUS_DIR}/bin/nexus start
ExecStop=${NEXUS_DIR}/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOL

# Enable and start Nexus
sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus
sudo systemctl status nexus

