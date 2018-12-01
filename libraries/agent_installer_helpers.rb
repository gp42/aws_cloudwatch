module AWSCloudwatch
  module AgentInstallerHelpers
    include Chef::Mixin::ShellOut

    def file_from_uri(uri)
      u = URI.parse(uri)
         ::File.basename(u.path)
    end

    # TODO: verify_installer needs a unit-test
    def verify_installer(args)
      sig = args['sig']
      package = args['package']
      gpg = args['gpg']
      fingerprint = args['fingerprint']
      cwd = args['cwd']
      platform = args['platform']

      env = {
              'GPG_FILE' => gpg,
              'EXPECTED_FINGERPRINT' => fingerprint,
              'SIG_FILE' => sig,
              'PACKAGE_FILE' => package
            }

      code_linux =<<-'EOC'
        gpg --import "$GPG_FILE" 2>&1

        key="$(gpg "$GPG_FILE" | sed 's/pub\s*.*\///g' | sed 's/\s.*//g')"
        test $? -ne 0 &&\
          echo 'ERROR: could not retrieve key from gpg file' &&\
            exit 1

        fingerprint="$(gpg --fingerprint $key | grep 'Key fingerprint' | sed 's/\s*Key fingerprint = //g' | tr -d ' ')"
        test $? -ne 0 &&\
          echo "ERROR: could not retrieve fingerprint from key '$key'" &&\
            exit 1

        test "$fingerprint" != "$EXPECTED_FINGERPRINT" &&\
          echo "ERROR: fingerprint '$fingerprint' for key '$key' does not match the expected: '$EXPECTED_FINGERPRINT'" &&\
            exit 1

        res="$(gpg --verify "$SIG_FILE" "$PACKAGE_FILE" 2>&1)"
        test $? -ne 0 &&\
          echo "ERROR: cannot verify file '$PACKAGE_FILE' with sig '$SIG_FILE'" &&\
            exit 1

        echo "$res" | grep 'gpg: Good signature'
        test $? -ne 0 &&\
          echo "ERROR: cannot verify file '$PACKAGE_FILE' with sig '$SIG_FILE' - no 'Good signature' message" &&\
            exit 1

        exit 0
      EOC

      # TODO: verify_installer_windows
      code_windows =<<-'EOW'
        Exit 0
      EOW

      platform == 'windows' ?
          code = code_windows : code = code_linux

      cmd = shell_out!(code, :env => env, :cwd => cwd)
      cmd.stderr.empty?

    end
  end
end