class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.13.1/metaphor-cli_v0.13.1_source.tar.gz"
  sha256 "8bae8ee2013b9b90c4a4e68c0399f8d7583d22b8da058d023a479a915530dd8d"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.13.1"
    sha256 arm64_tahoe:   "566e34719bb5bb7c0074a69cf7c4b9e1917a01088bbd509e29df34f6dddb010c"
    sha256 arm64_sequoia: "dc840fce35c6e54eb1a5432238934314157821e2e7fe6bd81408332cf4013861"
    sha256 arm64_sonoma:  "4542af6eea6019039ee561ad09dc6a6fde0f4dbbaffaef111bbc209f3396d8c9"
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
