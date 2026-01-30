class CcSwitchCli < Formula
  desc "Command-Line Management Tool for Claude Code, Codex & Gemini CLI"
  homepage "https://github.com/kingcanfish/cc-switch-cli"
  version "0.0.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.0.6/cc-switch-cli-v0.0.6-darwin-arm64.tar.gz"
      sha256 "2f6d7bf2f5a91be99b0c12d73c2b9851c7cd302419345532ac575f292cbb69e0"
    end
    on_intel do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.0.6/cc-switch-cli-v0.0.6-darwin-x64.tar.gz"
      sha256 "2143381018e9fe21736ea8d975dc3d8cb85ce0ef73c284cdbd8f49aad8970def"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.0.6/cc-switch-cli-v0.0.6-linux-arm64-musl.tar.gz"
      sha256 "7954d1c2629257f688b468ac67c201d5a4cb8593b544e9a765bef77f90d31d66"
    end
    on_intel do
      url "https://github.com/kingcanfish/cc-switch-cli/releases/download/v0.0.6/cc-switch-cli-v0.0.6-linux-x64-musl.tar.gz"
      sha256 "8c1f7ce79a732ea15de47c802ed2bcbd66906f67e57c3463febb572623092c74"
    end
  end

  def install
    bin.install "cc-switch-cli"
  end

  test do
    system "#{bin}/cc-switch-cli", "--help"
  end
end
