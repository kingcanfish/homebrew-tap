class CcSwitchCli < Formula
  desc "Command-Line Management Tool for Claude Code, Codex & Gemini CLI"
  homepage "https://github.com/kingcanfish/cc-switch-cli"
  version "0.1.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.3/cc-switch-cli-v0.1.3-darwin-arm64.tar.gz"
      sha256 "58ab5e23a2934c7b075ae023c18398afb286f77acd4fb980d898aa9e31ff679a"
    end
    on_intel do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.3/cc-switch-cli-v0.1.3-darwin-x64.tar.gz"
      sha256 "530b63e06040f85fde349b5d30c76eac4695d83a54f3f43448586caa07086236"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.3/cc-switch-cli-v0.1.3-linux-arm64-musl.tar.gz"
      sha256 "ff88ddde48ca44da52767fda685350ceb080c6fdc43fc2211804c63b4aa08c6b"
    end
    on_intel do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.3/cc-switch-cli-v0.1.3-linux-x64-musl.tar.gz"
      sha256 "6dd18e54996ba536505170ee6555cc1c7e1d87ef59a2b7524b731bd68775d371"
    end
  end

  def install
    bin.install "cc-switch-cli"
  end

  test do
    system "#{bin}/cc-switch-cli", "--help"
  end
end
