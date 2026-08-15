class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.10.5/metaphor-cli_v0.10.5_source.tar.gz"
  sha256 "02df8e97d541e41365ba665c6ac752a9900b67c97067da3f1578863c59e29927"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.10.5"
    sha256 arm64_tahoe:   "6df02e3cdffb144391a55b60fd352e85b2da0272ddd4299b452901a93733d98f"
    sha256 arm64_sequoia: "c1ca08966bdd7070e5bcce0ae1bb9e19dc5f43b2484a2e098ff4fd7fcf85d281"
    sha256 arm64_sonoma:  "cf01f7501a8f9904741638aa40ef0a910111b720287bff009d8a1774671a02c2"
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
