resource_name :security_policy

default_action :configure

property :policy_template, String, required: false, default: 'C:\Windows\security\templates\security_policies.inf'
property :database, String, required: false, default: 'C:\Windows\security\database\security_policies.sdb'
property :log_location, String, default: 'C:\Windows\security\logs\security_policies.log'

action :configure do
  template new_resource.policy_template do
    source 'security_policy.inf.erb'
    cookbook 'Windows_2012_MS_STIG'
    action :create
  end

  execute 'Configure security database' do
    command "Secedit /configure /db #{new_resource.database} /cfg #{new_resource.policy_template} /log #{new_resource.log_location}"
    live_stream true
    action :run
  end
end

action :export do
  execute 'Export security database to inf file' do
    command "Secedit /export /cfg #{new_resource.policy_template} /log #{new_resource.log_location}"
    live_stream true
    action :run
  end
end

action :import do
  template "#{new_resource.policy_template}" do
    source 'security_policy.inf.erb'
    action :create
  end

  execute 'Import and create security database' do
    command "Secedit /import /db #{new_resource.database} /cfg #{new_resource.policy_template} /log #{new_resource.log_location} /overwrite"
    live_stream true
    action :run
  end
end
