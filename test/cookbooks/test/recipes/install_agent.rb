#
# Cookbook:: test
# Recipe:: install_agent
#
# Copyright:: 2018, The Authors, All Rights Reserved.

aws_cloudwatch_agent 'default' do
  action [:install, :configure]
end