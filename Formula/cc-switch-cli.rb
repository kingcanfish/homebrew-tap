class CcSwitchCli < Formula
  desc "Command-Line Management Tool for Claude Code, Codex & Gemini CLI"
  homepage "https://github.com/kingcanfish/cc-switch-cli"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.0/cc-switch-cli-v0.1.0-darwin-arm64.tar.gz"
      sha256 "d00ad2e166b85080748d46e733fe80f6ed94826ac69acc177245f28cfc984045"
    end
    on_intel do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.0/cc-switch-cli-v0.1.0-darwin-x64.tar.gz"
      sha256 "6b6c302cce3e275f3cbfc0bbf174ba49fb5559d62906cdf6ba30b5e25e63ba66"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.0/cc-switch-cli-v0.1.0-linux-arm64-musl.tar.gz"
      sha256 "bbb13bdea6d412580ff0aeb6e0a4d0df637b43dc0389f388249e38c9e2c2f5a3"
    end
    on_intel do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.0/cc-switch-cli-v0.1.0-linux-x64-musl.tar.gz"
      sha256 "520b5a3d682678159b020ee8ed82edbc451465b927117df0790387d13bb80b47"
    end
  end

  def install
    bin.install "cc-switch-cli"
  end

  test do
    system "#{bin}/cc-switch-cli", "--help"
  end
end
