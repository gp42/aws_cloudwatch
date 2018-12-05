#
# Cookbook:: test
# Recipe:: install_agent_with_prop
#
# Copyright:: 2018, The Authors, All Rights Reserved.

aws_cloudwatch_agent 'default' do
  action          [:install, :configure]
  config_params   :shared_credential_profile => 'test_profile',
                  :shared_credential_file => '/etc/test_credential_file',
                  :http_proxy => 'http://192.168.0.1',
                  :https_proxy => 'https://192.168.0.1',
                  :no_proxy => 'http://192.168.0.10'
  json_config     'amazon-cloudwatch-agent.json.erb'
end