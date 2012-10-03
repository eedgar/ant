filename = node['ant']['url'].split('/')[-1]
localfile = "#{Chef::Config[:file_cache_path]}/#{filename}"
remote_file "#{localfile}" do
    source node['ant']['url']
    action :create_if_missing
end

bash "install ant" do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
  mkdir -p /usr/local/ant
  chmod -R 0755 /usr/local/ant
  tar zxf #{filename} -C /usr/local/ant --strip-components=1
  EOH
  not_if { ::File.exists?("/usr/local/ant/bin/ant") }
end

template "/etc/profile.d/ant.sh" do
      source "antrc.erb"
        mode "0644"
end
