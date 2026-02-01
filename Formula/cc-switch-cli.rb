class CcSwitchCli < Formula
  desc "Command-Line Management Tool for Claude Code, Codex & Gemini CLI"
  homepage "https://github.com/kingcanfish/cc-switch-cli"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.1/cc-switch-cli-v0.1.1-darwin-arm64.tar.gz"
      sha256 "bd843fc130c9f437aafe74d2b418fcd8497d9ed3cfb80dc6b741d9e7e3e7b880"
    end
    on_intel do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.1/cc-switch-cli-v0.1.1-darwin-x64.tar.gz"
      sha256 "647085d7e2b891d0df85b649fa3f8b406fbac4761e5675acdd449987516428f3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.1/cc-switch-cli-v0.1.1-linux-arm64-musl.tar.gz"
      sha256 "2c0bd5f19fa8862ccbf61400c229f2cf5e30260be2216ab2e7cd13c2d851b591"
    end
    on_intel do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.1.1/cc-switch-cli-v0.1.1-linux-x64-musl.tar.gz"
      sha256 "d44f4b9248e8101fd150a6a621429eb5c48b3904897d6822e0bf2a4ca0acb28a"
    end
  end

  def install
    bin.install "cc-switch-cli"
  end

  test do
    system "#{bin}/cc-switch-cli", "--help"
  end
end
