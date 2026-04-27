# typed: strict
# frozen_string_literal: true

# Homebrew formula for the Foreman server runtime.
class ForemanServer < Formula
  desc "Foreman's local node runtime"
  homepage "https://github.com/Vokality/foreman"
  version "0.1.13"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Vokality/foreman/releases/download/server-v0.1.13/foreman-server-0.1.13-aarch64-apple-darwin.tar.gz"
      sha256 "b86d2cca2894a78ff99726dfaf6dc22fb0e0aae248a2099ab4c72d6ff05be88e"
    else
      url "https://github.com/Vokality/foreman/releases/download/server-v0.1.13/foreman-server-0.1.13-x86_64-apple-darwin.tar.gz"
      sha256 "d0e68f70f9355fd0bb18c629b0ed44e50f1eb32f3c0ece3b30ff0c275f04a3f4"
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
