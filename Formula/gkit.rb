class Gkit < Formula
  desc "gkit — a transparent git/ssh toolkit: ssh keys, hooked clone, log-off check, stmb"
  homepage "https://github.com/teeckoo/gkit"
  version "0.15.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/teeckoo/gkit/releases/download/v0.15.1/gkit-aarch64-apple-darwin.tar.xz"
      sha256 "346e6da3ec3e07a5398fbf1e7106568a574ed0825f4dcf556b9166ec37c9cd82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/teeckoo/gkit/releases/download/v0.15.1/gkit-x86_64-apple-darwin.tar.xz"
      sha256 "0e874fa599aaa0e6d8c6089fe1968817f5d5778b1bd83ed39431ee447fbf1ff3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/teeckoo/gkit/releases/download/v0.15.1/gkit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6fd5de96b55c1d893b4ead345ea4b2f682e353a3af51cc000798c48d00e15687"
    end
    if Hardware::CPU.intel?
      url "https://github.com/teeckoo/gkit/releases/download/v0.15.1/gkit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e6e406ce6e2c1580b67a29737cda125633a5e721df3510c768e9a67090b96d8b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "gkit" if OS.mac? && Hardware::CPU.arm?
    bin.install "gkit" if OS.mac? && Hardware::CPU.intel?
    bin.install "gkit" if OS.linux? && Hardware::CPU.arm?
    bin.install "gkit" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
