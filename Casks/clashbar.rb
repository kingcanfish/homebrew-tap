cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  # Users who already manage their own mihomo core get the build without a bundled core.
  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.4.0"

  on_arm do
    sha256 has_core ? "56e21a9b767fbef642a61c8f353cfb196b1906b4d7294a947ed19c44bc6857f5" \
                    : "a966483dce797171c95d69be0d363ff3737eab8aab603555d31e43acd7b0539e"
  end
  on_intel do
    sha256 has_core ? "a52949e44d11148ac129c14481edbc5f9a08082625c287d8f04bcbd4a0b27e4f" \
                    : "f8ac8c3a29816bb906375e72368d514d248ffaa182e3e1ddc464cd554f3d981a"
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
