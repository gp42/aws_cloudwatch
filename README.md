# AWS Cloudwatch Cookbook
[![Build Status](https://travis-ci.org/gp42/aws_cloudwatch.svg?branch=master)](https://travis-ci.org/gp42/aws_cloudwatch) [![Cookbook Version](https://img.shields.io/cookbook/v/aws_cloudwatch.svg)](https://supermarket.chef.io/cookbooks/aws_cloudwatch)

This cookbook installs and configures [AWS CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html).

## Platform Support

* Ubuntu 14.04, 16.04, 18.04
* Centos 6, 7
* Fedora 29
* Amazon Linux

## Cookbook Dependencies

## Usage

Place a dependency on the aws_cloudwatch cookbook in your cookbook's metadata.rb

```
depends 'aws_cloudwatch', '~> 1.0.2'
```

Then in a recipe:

```
aws_cloudwatch_agent 'default' do
  action      [:install, :configure, :restart]
  json_config 'amazon-cloudwatch-agent.json.erb'
end
```

### json_config

Amazon CloudWatch Agent configuration file which defines which metrics/logs are collected.
Place the `amazon-cloudwatch-agent.json.erb` file to `templates` directory. This is an agent configuration for metrics and logs collection.
See AWS documentation for more information: [Manually Create or Edit the CloudWatch Agent Configuration File](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html#CloudWatch-Agent-Configuration-File-Complete-Example)


### config

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

#### Parameters

* `action` - Possible actions with the agent: `:install`, `:configure`, `:remove`, `:start`, `:stop`, `:restart`
* `config` - A template name for a custom `test-config.toml` file
* `config_params` - A hash with `test-config.toml` parameters
* `json_config` - A template name for an `amazon-cloudwatch-agent.json` file

#### Example

```
aws_cloudwatch_agent 'default' do
  action          [:install, :configure, :restart]
  json_config     'amazon-cloudwatch-agent.json.erb'
  config_params   :shared_credential_profile => 'test_profile',
                  :shared_credential_file => '/etc/test_credential_file',
                  :http_proxy => 'http://192.168.0.1',
                  :https_proxy => 'https://192.168.0.1',
                  :no_proxy => 'http://192.168.0.10'
end
```
