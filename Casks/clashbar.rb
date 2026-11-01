cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  # Users who already manage their own mihomo core get the build without a bundled core.
  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.4.4"

  on_arm do
    sha256 has_core ? "7591fa9fd83ce223589cc3d3a0dcb53e59a7856e82eee40280fb52bee533bd0e" \
                    : "f9dc6faee101277a1ceae248ecd11735f92e6b17d699fbf109052f4972cbbcdc"
  end
  on_intel do
    sha256 has_core ? "1ffc4c650360a20ff176eec548f63d7e8925ff0f9d61a74557e98af9d799f6b2" \
                    : "20c1ddd912506d9492f6b79f7d753e326c7d6191a07aa0b04b18999abdd54671"
  end

  url "https://github.com/kingcanfish/ClashBar/releases/download/v#{version}/ClashBar-#{version}-#{arch}#{core_suffix}.dmg"
  name "ClashBar"
  desc "Menu bar proxy client based on Mihomo"
  homepage "https://github.com/kingcanfish/ClashBar"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "ClashBar.app"

  postflight_steps do
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/ClashBar.app"]
  end

  uninstall_postflight_steps do
    run "/bin/launchctl", args: ["bootout", "system/com.clashbar.helper"],
        sudo: true, must_succeed: false
    run "/bin/rm",
        args: ["-f", "/Library/LaunchDaemons/com.clashbar.helper.plist",
               "/Library/PrivilegedHelperTools/com.clashbar.helper",
               "/Library/PrivilegedHelperTools/com.clashbar.helper.version"],
        sudo: true, must_succeed: false
  end

  uninstall launchctl: "com.clashbar.helper",
            quit:      "com.clashbar"

  zap trash: [
    "~/Library/Application Support/com.clashbar",
    "~/Library/Caches/com.clashbar",
    "~/Library/Preferences/com.clashbar.plist",
  ]
end
