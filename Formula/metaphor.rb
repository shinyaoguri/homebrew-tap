class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.8.1/metaphor-cli_v0.8.1_source.tar.gz"
  sha256 "bd436f4b351517d623a10ac317ca2e721121f368b50e2c4ed0e344de15f54db0"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.8.1"
    sha256 arm64_tahoe:   "51c5af6ebf4a07db68dcbe82ce0a022df7a654f862678786b7c2beeb92f1da29"
    sha256 arm64_sequoia: "ed70e90faa4587260c6342d0dc240002a7a5239433ca5ec2470833ef802854ad"
    sha256 arm64_sonoma:  "a4433d8b195aa3adfa752b390b4cd2d74d686a85f13b573785e33a8a7db5814d"
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
