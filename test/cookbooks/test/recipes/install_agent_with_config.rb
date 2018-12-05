#
# Cookbook:: test
# Recipe:: install_agent_with_params
#
# Copyright:: 2018, The Authors, All Rights Reserved.

aws_cloudwatch_agent 'default' do
  action      [:install, :configure]
  config      'test-config.toml.erb'
  json_config 'amazon-cloudwatch-agent.json.erb'
end