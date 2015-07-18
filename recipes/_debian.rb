#
# Author:: Leonard TAVAE (<leonard.tavae@gmail.com>)
# Cookbook Name:: fusioninventory-agent
#
# Copyright 2015
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

apt_repository 'fusioninventory' do
  uri 'http://debian.fusioninventory.org/debian/'
  distribution node['lsb']['codename']
  components ['main']
  key 'http://debian.fusioninventory.org/debian/archive.key'
  action :add
end

package 'fusioninventory-agent' do
  action [:install]
end

template "#{node['fusioninventory-agent']['conf_dir']}/agent.cfg" do
  source 'agent.cfg.erb'
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[fusioninventory-agent]', :immediately
end

template '/etc/default/fusioninventory-agent' do
  source 'fusioninventory-agent.erb'
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[fusioninventory-agent]', :immediately
end

service node['fusioninventory-agent']['service'] do
  supports status: true, restart: true
  action [:enable, :start]
end
