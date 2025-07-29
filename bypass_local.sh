echo "0.0.0.0 deviceenrollment.apple.com" >> /etc/hosts
echo "0.0.0.0 mdmenrollment.apple.com" >> /etc/hosts
echo "0.0.0.0 iprofiles.apple.com" >>  /etc/hosts
echo -e "${GRN}成功屏蔽网络验证及MDM绕过..."
touch /Volumes/Data/private/var/db/.AppleSetupDone
rm -rf /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
rm -rf /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

echo -e "${GRN}MDM 已成功绕过!${NC}"
echo -e "${NC}请重启Mac....${NC}"
