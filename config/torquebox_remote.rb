TorqueBox::RemoteDeploy.configure do
  torquebox_home "/opt/torquebox-current"
  hostname "77.95.120.68"
  port "22"
  user "sm"
  key "~/.ssh/id_rsa"
  sudo false
end