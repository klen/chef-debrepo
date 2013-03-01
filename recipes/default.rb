#
# Cookbook Name:: debrepo
# Recipe:: default
#
# Copyright 2013, Kirill Klenov
#

include_recipe "nginx"

# Setup packages
package "apt-utils"
package "dpkg-dev"

packages_dir = "#{ node[:debrepo][:source_dir] }/#{ node[:debrepo][:name] }" 

# Create directory for deb packages
directory packages_dir do
    user node[:nginx][:user]
    group node[:nginx][:user]
end

template "#{ node[:debrepo][:source_dir] }/autorepo" do
    source "autorepo.erb"
    user node[:nginx][:user]
    mode 00777
end

execute "scan" do
    command "#{ node[:debrepo][:source_dir]  }/autorepo"
    user node[:nginx][:user]
    cwd node[:debrepo][:source_dir]
end

if node[:debrepo][:nginx_proxy]
    
    # Enable site
    template "#{node[:nginx][:directories][:conf_dir]}/sites-available/debrepo.conf" do
    source      "nginx.conf.erb"
    owner       'root'
    group       'root'
    mode        '0644'

    if File.exists?("#{node[:nginx][:directories][:conf_dir]}/sites-enabled/debrepo.conf")
        notifies  :restart, 'service[nginx]'
    end
    end

    nginx_site "debrepo" do
        enable true
    end

else

    nginx_site "debrepo" do
        disable true
    end

end
