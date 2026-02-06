class AiappScanner < Formula
  include Language::Python::Virtualenv

  desc "Scan macOS for installed AI applications and CLI tools"
  homepage "https://github.com/ronaldbradford/aiapp-scanner"
  url "https://github.com/ronaldbradford/aiapp-scanner/archive/v0.1.0.tar.gz"
  sha256 "3f5e28b1fff4260dc6fa9cc1986d2aade792ace3300e85f7fe2d8aa07846bffe"
  license "MIT"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    # Install default configuration
    (etc/"aiapp-scanner").mkpath
    (etc/"aiapp-scanner").install "scanner_config.json" => "config.json"

    # Create symlink for config in standard location
    (prefix/"share/aiapp-scanner").mkpath
    (prefix/"share/aiapp-scanner").install_symlink etc/"aiapp-scanner/config.json"
  end

  def post_install
    # Create user config directory
    (var/"lib/aiapp-scanner").mkpath
  end

  def caveats
    <<~EOS
      Configuration file installed to:
        #{etc}/aiapp-scanner/config.json

      To customize the configuration:
        1. Copy to user directory:
           mkdir -p ~/.config/aiapp-scanner
           cp #{etc}/aiapp-scanner/config.json ~/.config/aiapp-scanner/

        2. Edit the file with your settings

      To update configuration from remote URL:
        aiapp-scanner --update-config

      To run a scan:
        aiapp-scanner --pretty

      To schedule daily scans with launchd, see:
        #{HOMEBREW_PREFIX}/share/aiapp-scanner/README.md
    EOS
  end

  test do
    output = shell_output("#{bin}/aiapp-scanner --create-default-config 2>&1")
    assert_match "Default configuration created", output

    output = shell_output("#{bin}/aiapp-scanner --pretty")
    assert_match "scan_metadata", output
  end
end
