
#!/bin/bash

# Define color codes
RED='\033[1;31m'
GRN='\033[1;32m'
BLU='\033[1;34m'
YEL='\033[1;33m'
PUR='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

# Display header
echo -e "${CYAN}MDM 绕过 —— by fineJune${NC}"
echo ""

# Prompt user for choice
PS3='输入1绕过MDM: '
options=("绕过MDM（选我）" "重启系统" "禁用通知 (SIP)" "禁用通知 (Recovery)" "检查MDM状态")
select opt in "${options[@]}"; do
    case $opt in
        "绕过MDM（选我）")
            # Bypass MDM from Recovery
            echo -e "${YEL}开始绕过MDM"
            if [ -d "/Volumes/Macintosh HD - Data" ]; then
                diskutil rename "Macintosh HD - Data" "Data"
            fi

            # Create Temporary User
            echo -e "${NC}创建账户"
            read -p "输入电脑名称(默认为 'Macbook'): " realName
            realName="${realName:=Macbook}"
            read -p "输入账户名称(默认为 'Users'): " username
            username="${username:=User}"
            read -p "输入账号密码 (默认是 '1234'): " passw
            passw="${passw:=1234}"

            # Create User
            dscl_path='/Volumes/Macintosh\ HD/private/var/db/dslocal/nodes/Default'
            echo -e "${GREEN}创建账户中...."
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "506"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
            mkdir "/Volumes/Macintosh\ HD/Users/$username"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
            dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
            dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username

            # Block MDM domains
            echo "0.0.0.0 deviceenrollment.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
            echo "0.0.0.0 mdmenrollment.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
            echo "0.0.0.0 iprofiles.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
            echo -e "${GRN}成功屏蔽网络验证及MDM绕过..."

            # Remove configuration profiles
            touch /Volumes/Macintosh\ HD/private/var/db/.AppleSetupDone
            rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
            rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
            touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
            touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

            echo -e "${GRN}MDM 已成功绕过!${NC}"
            echo -e "${NC}请重启Mac....${NC}"
            break
            ;;
        "禁用通知 (SIP)")
            # Disable Notification (SIP)
            echo -e "${RED}请输入密码继续:${NC}"
            sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
            sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
            sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
            sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
            break
            ;;
        "禁用通知 (Recovery)")
            # Disable Notification (Recovery)
            rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
            rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
            touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
            touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
            break
            ;;
        "检查MDM状态")
            # Check MDM Enrollment
            echo ""
            echo -e "${GRN}检查MDM状态中，报错代表成功...${NC}"
            echo ""
            echo -e "${RED}输入密码继续:${NC}"
            echo ""
            sudo profiles show -type enrollment
            break
            ;;
        "重启系统")
            # Reboot & Exit
            echo "重启中..."
            reboot
            break
            ;;
        *) echo "输入了错误的选项 $REPLY" ;;
    esac
done
