class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.10.6/metaphor-cli_v0.10.6_source.tar.gz"
  sha256 "d32e6baca5a37180d144195a38d69c5f2c000e699d7ba1d2929097f2c1016518"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.10.6"
    sha256 arm64_tahoe:   "97b00ab799af42ea2f46700febebeacb7ca16e895093768c2c77d7ca97a3349d"
    sha256 arm64_sequoia: "25d410ee2a9bd5235de4282e4ede3030e7d15f0e2f306de49fe3a51ad96039dd"
    sha256 arm64_sonoma:  "31e02a21f6acc2dfeee530930d8f931dd26727f1480e1647267062d344d92b85"
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
