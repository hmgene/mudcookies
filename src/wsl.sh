#https://www.hanselman.com/blog/how-to-ssh-into-wsl2-on-windows-10-from-an-external-machine
echo "
  netsh interface portproxy show v4tov4
  netsh int portproxy reset all
  netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=22 connectaddress=172.30.53.115 connectport=22
  netsh advfirewall firewall add rule name="Open Port 22 for WSL2" dir=in action=allow protocol=TCP localport=22
  netsh interface portproxy show v4tov4
"

#https://www.hanselman.com/blog/how-to-ssh-into-wsl2-on-windows-10-from-an-external-machine
ip=129.22.242.198
ip=172.19.196.21
port=22
echo "
netsh interface portproxy show v4tov4
netsh int portproxy reset all
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=$port connectaddress=$ip connectport=$port
netsh advfirewall firewall add rule name=\"Open Port $port for WSL2\" dir=in action=allow protocol=TCP localport=$port
netsh interface portproxy show v4tov4
"



