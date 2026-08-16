class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.13.0/metaphor-cli_v0.13.0_source.tar.gz"
  sha256 "bb7ef18c3b9f946fedbad1dcdba9e58fb5e75817ca198453a5897b13a1b95d30"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.13.0"
    sha256 arm64_tahoe:   "4dd4feb77b4e0fb6de5b3e20e29a809bbd0b4f1b132f7d76552993e4aebefb11"
    sha256 arm64_sequoia: "fafe3d150ca956d9d02e14276a87399d2bd6f15c21a8307c3a1676100556ec55"
    sha256 arm64_sonoma:  "7169c118d6500645d5424510c30b7a9146e6a7e042d2bda0050009c14f8327e3"
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
