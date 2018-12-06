#
# Cookbook:: test
# Recipe:: install_remove_agent
#
# Copyright:: 2018, The Authors, All Rights Reserved.

aws_cloudwatch_agent 'default' do
  action      [:install, :configure, :remove]
  json_config 'amazon-cloudwatch-agent.json.erb'
end