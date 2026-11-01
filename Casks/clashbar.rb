cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  # Users who already manage their own mihomo core get the build without a bundled core.
  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.4.1"

  on_arm do
    sha256 has_core ? "4eb086210e87b11c37985695403c04a02d517c5c9266e4218e0b1810f491a993" \
                    : "dff87616bef115f9dd3b3942b7deace126862fdcef2f604ba0f27ced4be3b3ef"
  end
  on_intel do
    sha256 has_core ? "4f65cb9c9dd5533a97c89bb176df3f310edc64549d2595bf7bff3803a09132de" \
                    : "06d80eca23add01f0378425035093575086d3a2eee78f4ed05d5cdf06ba99644"
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
