# AWS Cloudwatch Cookbook

This cookbook is created to install and configure AWS Cloudwatch agent.

## Scope

## Requirements

## Platform Support

## Cookbook Dependencies

## Usage

Place a dependency on the aws_cloudwatch cookbook in your cookbook's metadata.rb
```
depends 'aws_cloudwatch', '~> 0.1.0'
```

Then in a recipe:
```
aws_cloudwatch_agent 'default' do
  action :install
end
```

The configuration file is at /opt/aws/amazon-cloudwatch-agent/etc.
See [AWS Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-on-first-instance.html#CloudWatch-Agent-profile-instance-first) for more info.
Default file looks like this:
```
# This common-config is used to configure items used for both ssm and cloudwatch access


## Configuration for shared credential.
## Default credential strategy will be used if it is absent here:
##            Instance role is used for EC2 case by default.
##            AmazonCloudWatchAgent profile is used for onPremise case by default.
# [credentials]
#    shared_credential_profile = "{profile_name}"
#    shared_credential_file= "{file_name}"

## Configuration for proxy.
## System-wide environment-variable will be read if it is absent here.
## i.e. HTTP_PROXY/http_proxy; HTTPS_PROXY/https_proxy; NO_PROXY/no_proxy
## Note: system-wide environment-variable is not accessible when using ssm run-command.
## Absent in both here and environment-variable means no proxy will be used.
# [proxy]
#    http_proxy = "{http_url}"
#    https_proxy = "{https_url}"
#    no_proxy = "{domain}"
```

You can modify this configuration by overriding attributes:
```
default['aws_cloudwatch']['config']['params']['shared_credential_profile']
default['aws_cloudwatch']['config']['params']['shared_credential_file']
default['aws_cloudwatch']['config']['params']['http_proxy']
default['aws_cloudwatch']['config']['params']['https_proxy']
default['aws_cloudwatch']['config']['params']['no_proxy']
```

It is also possible to configure it with environment variables instead:
```
SHARED_CREDENTIAL_PROFILE
SHARED_CREDENTIAL_FILE
HTTP_PROXY
HTTPS_PROXY
NO_PROXY
```

If you want to provide your own template for the configuration file, then you need to supply it as a `config`
parameter to the resource:
```
aws_cloudwatch_agent 'default' do
  action :install
  config <config_template.erb>
end
```

## Resources overview
### aws_cloudwatch_agent
The `aws_cloudwatch_agent` resource installs AWS Cloudwatch Agent.

#### Example
```
aws_cloudwatch_agent 'default' do
  action            :install
  config_params     shared_credential_profile =>

end
```