cask "aistat" do
  version "0.4.0"
  sha256 "fe361f2d88cf64aeaed884a805d3d624527d546fa24a659fcbf19f84305555d1"

  url "https://github.com/kingcanfish/aistat/releases/download/v#{version}/AIStat_#{version}_universal.dmg"
  name "AIStat"
  desc "Menu bar app that watches AI service status pages"
  homepage "https://github.com/kingcanfish/aistat"

  # macOS 14. The native app uses @Observable and ContentUnavailableView, both
  # of which landed in Sonoma. This is a floor the Tauri build did not have.
  depends_on macos: :sonoma

  app "AIStat.app"

  zap trash: [
    "~/Library/Application Support/com.aistat.app",
    "~/Library/Caches/com.aistat.app",
    "~/Library/Saved Application State/com.aistat.app.savedState",
  ]

  caveats <<~EOS
    AIStat is not signed with an Apple Developer ID, so Gatekeeper will refuse
    to open it on first launch. Clear the quarantine flag once:

      xattr -dr com.apple.quarantine "/Applications/AIStat.app"

    AIStat runs in the menu bar only and has no Dock icon. Click the icon for
    the panel; Settings is in the panel's footer, or press Command-comma.
  EOS
end
