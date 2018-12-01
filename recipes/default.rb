#
# Cookbook:: aws_cloudwatch
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

node.default['aws_cloudwatch']['config']['params'] = {
  "shared_credential_profile": nil,
  "shared_credential_file": nil,
  "http_proxy": nil,
  "https_proxy": nil,
  "no_proxy": nil
}

aws_cloudwatch_agent 'default' do
  action :install
end