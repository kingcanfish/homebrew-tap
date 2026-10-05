cask "aistat" do
  version "0.4.1"
  sha256 "8cff1ea73d21cadbbd6132b037d91ee9a75fd9f0b30f00cf3b8368a736b02ed7"

  url "https://github.com/kingcanfish/aistat/releases/download/v#{version}/AIStat_#{version}_universal.dmg"
  name "AIStat"
  desc "Menu bar app that watches AI service status pages"
  homepage "https://github.com/kingcanfish/aistat"

  # macOS 26. The native app is drawn with Tahoe's Liquid Glass APIs, and
  # Package.swift sets the same floor. This is a floor the Tauri build did not have.
  depends_on macos: :tahoe

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
