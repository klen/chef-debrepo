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
package "devscripts"

packages_dir = "#{ node[:debrepo][:source_dir] }/#{ node[:debrepo][:name] }" 
packages_user = node[:debrepo][:nginx_proxy] ? node[:nginx][:user] : "root"
packages_group = node[:debrepo][:nginx_proxy] ? node[:nginx][:user] : "root"

# Create directory for deb packages
directory packages_dir do
    user packages_user
    group packages_group
    recursive true
end

# Directory for makes builds
directory "#{ node[:debrepo][:source_dir] }/build" do
    group "sudo"
    mode 00770
    recursive true
end

template "#{ node[:debrepo][:source_dir] }/autorepo" do
    source "autorepo.erb"
    user packages_user
    mode 00777
    variables(
        :source_dir => node[:debrepo][:source_dir],
        :user => packages_user,
        :group => packages_group,
        :name => node[:debrepo][:name]
    )
end

execute "scan" do
    command "#{ node[:debrepo][:source_dir]  }/autorepo"
    cwd node[:debrepo][:source_dir]
end

if node[:debrepo][:nginx_proxy]
    
    # Enable site
    template "#{node[:nginx][:directories][:conf_dir]}/sites-available/debrepo.conf" do
    source      "nginx.conf.erb"
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
