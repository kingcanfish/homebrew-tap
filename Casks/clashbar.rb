cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  # Users who already manage their own mihomo core get the build without a bundled core.
  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.4.3"

  on_arm do
    sha256 has_core ? "f86e09fca9e6fbfb29768feb6ceb3d150ce968646ef2ce48f4bdf01813d31ea7" \
                    : "c3827f6fcbc8bf5ec256082cb444073edc1948484049af21c6a086af791067d8"
  end
  on_intel do
    sha256 has_core ? "2adc98e85bb927543b2032c7b62534e2544bf54d81271d8c1ff0564d33c7fa2b" \
                    : "209074a862fbe0b895b2a2c219b7ac9706bd941ca0c07ea6238eb7f093e065de"
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
