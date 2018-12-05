#
# Cookbook:: test
# Recipe:: unit_incorrect_gpg_fingerprint
#
# Copyright:: 2018, The Authors, All Rights Reserved.


node.default['aws_cloudwatch']['gpg']['fingerprint'] = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

aws_cloudwatch_agent 'default' do
  action          [:install, :configure]
  ignore_failure  true
  json_config     'amazon-cloudwatch-agent.json.erb'
end