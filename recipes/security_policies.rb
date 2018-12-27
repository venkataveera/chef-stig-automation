# encoding: utf-8
Chef::Log.info "Remediations: Security Policies"

source_policy_file = "#{node['Windows_2012_MS_STIG']['security_policy']['source_policy_file']}"
target_policy_file = "#{node['Windows_2012_MS_STIG']['security_policy']['target_policy_file']}"

security_policy 'Export existing security policies to inf file' do
  policy_template "#{source_policy_file}"
  action :export
end

stig_patterns[:security_policies].each do |stig_id, pattern|

  Chef::Log.info "Remediate: #{stig_id} - Security Policy for #{pattern['name']} (#{pattern['policy']}) - #{pattern['value']}"

  ruby_block "#{stig_id} - Security Policy for #{pattern['policy']} #{pattern['value']}" do
    block do
      node.force_default['Windows_2012_MS_STIG']["#{pattern['type']}"]["#{pattern['policy']}"] = pattern['value']
    end

    # Guard condition based on:
    #  - Value comparision fails / succeeds
    only_if do
        # Remediate only if cmp attribte is present
        pattern['cmp'].nil? ||

        # Remediate failed comparisons (including missing values)
        (
          begin
            pso = powershell_out!("gc '#{source_policy_file}' | Select-String -Pattern '#{pattern['policy']}' | Select-Object -First 1")
            data = pso.stdout.to_s.split()[-1]
          rescue
            data = nil
          end

          data.nil? ||
          case pattern['cmp']
            when 'eq'
              pattern['value'].to_i != data.to_i
            when 'eq_str'
              (pattern['value'].to_s).eql?data.to_s
            when 'lt'
              data.to_i < pattern['value'].to_i
            when 'gt'
              pattern['value'].to_i > data.to_i || (pattern['exclude_zero'] && data.to_i == 0)
            else
              false
          end
        )
      end
  end
end

security_policy 'Configure SDB file to system' do
 policy_template "#{target_policy_file}"
 action :configure
end