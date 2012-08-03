TorqueBox::RemoteDeploy.configure do
  torquebox_home "/opt/torquebox-current"
  hostname "192.168.145.109"
  port "22"
  user "sm"
  key "~/.ssh/id_rsa"
  sudo false
end