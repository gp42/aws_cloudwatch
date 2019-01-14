module AWSCloudwatch
  class AgentInstaller < Chef::Resource
    require_relative "agent_installer_helpers.rb"
    include AWSCloudwatch::AgentInstallerHelpers

    resource_name :aws_cloudwatch_agent

    property :config, String
    property :json_config, String
    property :config_params, Hash, default: {'param' => 'value'}

    default_action :install

    provides :aws_cloudwatch_agent


    action :install do
      # Install dependencies
      node['aws_cloudwatch']['dependencies'][node['platform']].each do |p|
        package p do
          action  :install
        end
      end if node['aws_cloudwatch']['dependencies'][node['platform']]

      # Download installer
      package_files = {}
      ['package', 'sig'].each do |file|
        package_files[file] = ::File::join(Chef::Config[:file_cache_path], file_from_uri(node['aws_cloudwatch']['installers'][node[:platform]][file]))
        remote_file package_files[file] do
          action :create
          source node['aws_cloudwatch']['installers'][node[:platform]][file]
        end
      end

      package_files['gpg'] = ::File::join(Chef::Config[:file_cache_path], file_from_uri(node['aws_cloudwatch']['gpg']['public_key']))
      remote_file package_files['gpg'] do
        action :create
        notifies  :run, 'ruby_block[verify_installer]', :immediately
        source node['aws_cloudwatch']['gpg']['public_key']
      end

      # Verify installer
      ruby_block 'verify_installer' do
        action :nothing
        block do
          verify_args = {
            'platform' => node[:platform],
            'cwd' => Chef::Config[:file_cache_path],
            'fingerprint' => node['aws_cloudwatch']['gpg']['fingerprint']
          }
          verify_args.merge!(package_files)

          verify_installer(verify_args)
        end
      end

      # Install
      case node[:platform]
        when 'ubuntu', 'debian'
          dpkg_package 'amazon-cloudwatch-agent' do
            action  :install
            source  package_files['package']
          end
        else
          package 'amazon-cloudwatch-agent' do
            action  :install
            source  package_files['package']
          end
      end
    end

    action :configure do
      config = new_resource.config
      config_params = new_resource.config_params || {}

      config ? \
        config_source = config : \
        config_source = node['aws_cloudwatch']['config']['source']

      template ::File::join(config_path, node['aws_cloudwatch']['config']['file_name']) do
        action    :create
        source    config_source

        # Use a resource config-file template if not provided in properties
        unless config
          cookbook  'aws_cloudwatch'
          variables(
            shared_credential_profile: config_params[:shared_credential_profile] || \
                                       node['aws_cloudwatch']['config']['params']['shared_credential_profile'] || \
                                       ENV['SHARED_CREDENTIAL_PROFILE'],
            shared_credential_file: config_params[:shared_credential_file] || \
                                    node['aws_cloudwatch']['config']['params']['shared_credential_file'] || \
                                    ENV['SHARED_CREDENTIAL_FILE'],
            http_proxy: config_params[:http_proxy] || \
                        node['aws_cloudwatch']['config']['params']['http_proxy'] || \
                        ENV['HTTP_PROXY'],
            https_proxy: config_params[:https_proxy] || \
                         node['aws_cloudwatch']['config']['params']['https_proxy'] || \
                         ENV['HTTPS_PROXY'],
            no_proxy: config_params[:no_proxy] || \
                      node['aws_cloudwatch']['config']['params']['no_proxy'] || \
                      ENV['NO_PROXY']
          )
        end
      end

      if new_resource.json_config
        json_path = "#{::File::join(config_path, node['aws_cloudwatch']['config']['json_file_name'])}"
        agent_tom_path = "#{::File::join(config_path, 'amazon-cloudwatch-agent.toml')}"
        common_path = "#{::File::join(config_path, node['aws_cloudwatch']['config']['file_name'])}"
        template json_path do
          action    :create
          source    new_resource.json_config
        end
        script 'amazon-cloudwatch-agent-config-translator' do
          action :run
          not_if { ::File.exists?(agent_tom_path) }
          case node[:platform]
            when 'windows'
              # interpreter "powershell"
              # # TODO: Powershell draft
              # code <<-EOH
              #   ./amazon-cloudwatch-agent-ctl.ps1 -a start -m auto
              # EOH
            else
              interpreter "bash"
              code <<-EOH
                res="$(sudo /opt/aws/amazon-cloudwatch-agent/bin/config-translator --input #{json_path} --output #{agent_tom_path} --mode auto --config #{common_path})"
                echo "$res" | grep 'Valid Json input schema.'
                exit $?
              EOH
          end
        end
      end
    end

    action :start do
      script 'amazon-cloudwatch-agent-ctl_start' do
        action :run
        case node[:platform]
          when 'windows'
            interpreter "powershell"
            # TODO: Powershell draft
            code <<-EOH
              ./amazon-cloudwatch-agent-ctl.ps1 -a start -m auto
            EOH
          else
            interpreter "bash"
            code <<-EOH
              sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -m auto
              res="$(sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status)"
              echo "$res" | grep '"status": "running"'
              exit $?
            EOH
        end
      end
    end

    action :stop do
      script 'amazon-cloudwatch-agent-ctl_stop' do
        action :run
        case node[:platform]
          when 'windows'
              interpreter "powershell"
            # TODO: Powershell draft
            code <<-EOH
              ./amazon-cloudwatch-agent-ctl.ps1 -a stop -m auto
            EOH
          else
            interpreter "bash"
            code <<-EOH
              sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a stop -m auto
              res="$(sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status)"
              echo "$res" | grep '"status": "stopped"'
              exit $?
            EOH
        end
      end
    end

    action :restart do
      action_stop
      action_start
    end

    action :remove do
      case node[:platform]
        when 'ubuntu', 'debian'
          dpkg_package 'amazon-cloudwatch-agent' do
            action  :remove
          end
        else
          package 'amazon-cloudwatch-agent' do
            action  :remove
          end
      end
    end
  end
end