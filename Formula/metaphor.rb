class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.20.1/metaphor-cli_v0.20.1_source.tar.gz"
  sha256 "4b9ea4da75dac02f6e5f8ff45c3b9d87c511b90450c80de63f49ffcd9c82a684"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.20.1"
    sha256 arm64_tahoe:   "010f8a0f4235cfe6201e299bcaaa94f1b2565e96e929d8b419ee36d18b11e3d5"
    sha256 arm64_sequoia: "9d371c7b8f5804415158e5ec691693e4d0363a82627e2c50138e46cba1a73eea"
    sha256 arm64_sonoma:  "bd210d9162871965827b9349982d383f4a33c54ad6ad461279443f15d39f7ba2"
  end

  depends_on xcode: ["15.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    # Keep the real binary in libexec and expose it through a bin symlink — the
    # same layout as scripts/install.sh and `metaphor update self`, so every
    # install method resolves the binary to one place.
    libexec.install ".build/release/metaphor"
    bin.install_symlink libexec/"metaphor"
    pkgshare.install "Templates" => "templates"
  end

  test do
    assert_match "metaphor", shell_output("#{bin}/metaphor version")
    assert_match "Templates:", shell_output("#{bin}/metaphor --help")
  end
end
