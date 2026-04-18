# typed: strict
# frozen_string_literal: true

# Homebrew formula for the Foreman server runtime.
class ForemanServer < Formula
  desc "Foreman's local node runtime"
  homepage "https://github.com/Vokality/foreman"
  version "0.1.12"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Vokality/foreman/releases/download/server-v0.1.12/foreman-server-0.1.12-aarch64-apple-darwin.tar.gz"
      sha256 "9fe308979e279181a638c2844f64ff8503a676b2888825a6d77af83896a51a4e"
    else
      url "https://github.com/Vokality/foreman/releases/download/server-v0.1.12/foreman-server-0.1.12-x86_64-apple-darwin.tar.gz"
      sha256 "19394abc653e6b96bc6d98c710cc38cc05c28a05e8f0e57850d07800c45dada9"
    end
  end

  def install
    libexec.install Dir["README.md", "bin", "config", "scripts"]

    (bin/"foreman-server").write <<~SH
      #!/bin/bash
      export FOREMAN_INSTALL_CHANNEL=homebrew
      exec "#{opt_libexec}/bin/foreman-server" "$@"
    SH
    chmod 0755, bin/"foreman-server"
  end

  service do
    run [opt_bin/"foreman-server", "run"]
    keep_alive true
    environment_variables PATH: std_service_path_env
  end

  test do
    output = shell_output("#{bin}/foreman-server --help")
    assert_match "Foreman Server runtime and service manager", output
  end
end
