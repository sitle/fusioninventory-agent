#
# Author:: Mat Davies (<ashmere@gmail.com>)
# Cookbook Name:: fusioninventory-agent
#
# Copyright 2012
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# add the Fusioninventory-agent Repo
execute "apt-get update" do
  action :nothing
end
 
execute "add_fusioninventory_apt_key" do
  command "wget -O - http://debian.fusioninventory.org/debian/archive.key | apt-key add -"
  notifies :run, resources("execute[apt-get update]"), :immediately
end


template "/etc/apt/sources.list.d/fusioninventory-agent.list" do
  owner "root"
  mode "0644"
  source "fusioninventory-agent.list.erb"
  notifies :run, resources("execute[apt-get update]"), :immediately
end
 

pkgs = value_for_platform(
  [ "debian", "ubuntu" ] => {
    "default" => %w{ fusioninventory-agent }
  },
  "default" => %w{ fusioninventory-agent }
)

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template "#{node['fusioninventory-agent']['conf_dir']}/agent.cfg" do
  source "agent.cfg.erb"
  action :create
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/default/fusioninventory-agent" do
  source "fusioninventory-agent.erb"
  action :create
  owner "root"
  group "root"
  mode "0644"
end

service node['fusioninventory-agent']['service'] do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

