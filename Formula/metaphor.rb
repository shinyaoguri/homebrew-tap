class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.18.0/metaphor-cli_v0.18.0_source.tar.gz"
  sha256 "4933eb03b6c586bf9fecfcc375062d8e2cc939a1ab3bdb6c383e9dacb4764524"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.18.0"
    sha256 arm64_tahoe:   "0eba52c4042ce3245b53bcebeef00404407f811e40ce5857f035eabdb196b6ec"
    sha256 arm64_sequoia: "1c3ec6ee9413644edcc3cc2828674e232bfe92b5ee60738fa485bbdcd2c5062b"
    sha256 arm64_sonoma:  "7d779083bbb143b78cd051570afe2ba160dbd5e01b67a38ca2908ab8273362d0"
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
