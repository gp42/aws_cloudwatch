#
# Cookbook:: test
# Recipe:: install_start_stop_agent
#
# Copyright:: 2018, The Authors, All Rights Reserved.

aws_cloudwatch_agent 'default' do
  action      [:install, :configure, :restart, :stop]
  json_config 'amazon-cloudwatch-agent.json.erb'
end