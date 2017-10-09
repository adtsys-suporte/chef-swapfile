Chef::Log.info("********** Executing cron recipe! **********")
script 'create chef-swapfile' do
  interpreter 'bash'
  not_if { File.exists?('/var/chef-swapfile') }
  code <<-eof
    dd if=/dev/zero of=/var/chef-swapfile bs=1M count=2048 &&
    chmod 600 /var/chef-swapfile &&
    mkswap /var/chef-swapfile
  eof
end

mount '/dev/null' do  # swap file entry for fstab
  action :enable  # cannot mount; only add to fstab
  device '/var/chef-swapfile'
  fstype 'swap'
end

script 'activate swap' do
  interpreter 'bash'
  code 'swapon -a'
end
