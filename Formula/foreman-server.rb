# typed: strict
# frozen_string_literal: true

# Homebrew formula for the Foreman server runtime.
class ForemanServer < Formula
  desc "Foreman's local node runtime"
  homepage "https://github.com/Vokality/foreman"
  version "0.1.10"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Vokality/foreman/releases/download/server-v0.1.10/foreman-server-0.1.10-aarch64-apple-darwin.tar.gz"
      sha256 "14a58766937db67e6e2001b8e12ffb722f44eac95eefa736400613c211ff9f23"
    else
      url "https://github.com/Vokality/foreman/releases/download/server-v0.1.10/foreman-server-0.1.10-x86_64-apple-darwin.tar.gz"
      sha256 "00522b5c679539293ffe81c207b69d266da9c6380a6089b29e7e8cf8b39eca00"
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
    environment_variables FOREMAN_HOME: var/"foreman-server", PATH: std_service_path_env
  end

  test do
    output = shell_output("#{bin}/foreman-server --help")
    assert_match "Foreman Server runtime and service manager", output
  end
end
