class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.12.0/metaphor-cli_v0.12.0_source.tar.gz"
  sha256 "360b49e5e1b116a648ded31a38f7351b0eabc30f4d6cf9bbf290f3c48425fffd"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.12.0"
    sha256 arm64_tahoe:   "e4dbe973dd5cbe74d1f5a15195b244b92e751623f3f9364dd36249b0f3f77c33"
    sha256 arm64_sequoia: "693abd1d56c0ba1feba46338e647c6d076de7abeb1f36f1d03ff34b1383c6161"
    sha256 arm64_sonoma:  "0158b05cd2ea49e692bdf37dab027c041d082598cf271d2be745d4c4660c10b7"
  end

  depends_on xcode: ["15.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    # The binary links Syphon.framework via @rpath, resolved against @loader_path
    # (the directory of the *resolved* binary). Keep the framework beside the real
    # binary in libexec and expose the executable through a bin symlink — dyld
    # resolves the symlink before computing @loader_path, so it lands in libexec.
    libexec.install ".build/release/metaphor"
    libexec.install ".build/release/Syphon.framework"
    bin.install_symlink libexec/"metaphor"
    pkgshare.install "Templates" => "templates"
  end

  test do
    assert_match "metaphor", shell_output("#{bin}/metaphor version")
    assert_match "Templates:", shell_output("#{bin}/metaphor --help")
  end
end
