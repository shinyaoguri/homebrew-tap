class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.9.0/metaphor-cli_v0.9.0_source.tar.gz"
  sha256 "b253c422e371fed61f6d2368729a5f47e0d166552a2e12999263a7d8f1398c37"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.9.0"
    sha256 arm64_tahoe:   "cb773b9996d3e4f27c09913e6e18d6236e79a3d17c68ed1dbb8f825347bb1194"
    sha256 arm64_sequoia: "f5187753e8a822d2195bc51b68fe32d0fadddca07388ed6b3fe9ed10b6924d61"
    sha256 arm64_sonoma:  "028ec3bc75f6b72076cb61b3965bf84358b5c151fe1cd21b9055ee53207723e1"
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
