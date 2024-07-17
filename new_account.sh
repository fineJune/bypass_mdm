echo -e "${NC}创建账户"
read -p "输入电脑名称(默认为 'Macbook'): " realName
realName="${realName:=Macbook}"
read -p "输入账户名称(默认为 'Me'): " username
username="${username:=Me}"
read -p "输入账号密码 (默认是 '0000'): " passw
passw="${passw:=0000}"

# Create User
dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default'
echo -e "${GREEN}创建账户中...."
dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "502"
dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
mkdir "/Volumes/Data/Users/$username"
dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
