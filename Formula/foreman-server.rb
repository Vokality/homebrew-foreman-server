# typed: strict
# frozen_string_literal: true

# Homebrew formula for the Foreman server runtime.
class ForemanServer < Formula
  desc "Foreman's local node runtime"
  homepage "https://github.com/Vokality/foreman"
  version "0.1.11"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Vokality/foreman/releases/download/server-v0.1.11/foreman-server-0.1.11-aarch64-apple-darwin.tar.gz"
      sha256 "0a40e6d04e2377e523c21911bba8a75537200ae06217507a3e3e11623b08d3ee"
    else
      url "https://github.com/Vokality/foreman/releases/download/server-v0.1.11/foreman-server-0.1.11-x86_64-apple-darwin.tar.gz"
      sha256 "2e9f96b1e163fbdc6b3f61097e9d8f3d0947fa1bf36fa44f5170aa2d59895e25"
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
