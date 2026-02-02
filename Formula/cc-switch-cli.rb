class CcSwitchCli < Formula
  desc "Command-Line Management Tool for Claude Code, Codex & Gemini CLI"
  homepage "https://github.com/kingcanfish/cc-switch-cli"
  version "0.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.2/cc-switch-cli-v0.1.2-darwin-arm64.tar.gz"
      sha256 "94e8c8257aa74a774736e368b6f14ee0f4178cc50e36b6e270b67ee87fb07a3c"
    end
    on_intel do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.2/cc-switch-cli-v0.1.2-darwin-x64.tar.gz"
      sha256 "96935796f687547a433aab0fb57c7026fd0c515b4be42aad35962d5641705887"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.2/cc-switch-cli-v0.1.2-linux-arm64-musl.tar.gz"
      sha256 "4d6f6342a8ca761dc66875799f4d755f5dd5736b2d54fba73820b9ebd0e7b566"
    end
    on_intel do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.2/cc-switch-cli-v0.1.2-linux-x64-musl.tar.gz"
      sha256 "230747210860900213851f00101de143199cda577d33a445a0dad5ed4ac02b4d"
    end
  end

  def install
    bin.install "cc-switch-cli"
  end

  test do
    system "#{bin}/cc-switch-cli", "--help"
  end
end
