cask "aistat" do
  version "0.1.1"
  sha256 "b0a658ce418b7f9899c60649a8de5533ef833045589d728b0f1614c2227ef218"

  url "https://github.com/kingcanfish/aistat/releases/download/v#{version}/AIStat_#{version}_universal.dmg",
      verified: "github.com/kingcanfish/aistat/"
  name "AIStat"
  desc "Menu bar app that watches AI service status pages"
  homepage "https://github.com/kingcanfish/aistat"

  depends_on macos: :big_sur

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

    AIStat runs in the menu bar only and has no Dock icon.
  EOS
end
