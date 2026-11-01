cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  # Users who already manage their own mihomo core get the build without a bundled core.
  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.4.2"

  on_arm do
    sha256 has_core ? "2802cdb62f980eb3a3e0294297dfed0713a0ff4ff291e74891a135f91c55156f" \
                    : "79bcacd6199801d246d6e1750db2592744080eb654db3e8fc52db23144ccf442"
  end
  on_intel do
    sha256 has_core ? "cb4698a56ffb807beb74e07e79d5db7452dfedb7ef9d13745ac46beacb4cf07c" \
                    : "5e2c113640cc40dab120e4befb502924f351c75cb76d1cb2e34726c639d30aca"
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
