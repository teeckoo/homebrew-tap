class Gkit < Formula
  desc "gkit — a transparent git/ssh toolkit: ssh keys, hooked clone, log-off check, stmb"
  homepage "https://github.com/teeckoo/gkit"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/teeckoo/gkit/releases/download/v0.13.0/gkit-aarch64-apple-darwin.tar.xz"
      sha256 "74a49161a0c5847c898f3865a24df04d7f0df8a73fa67c0a7f91711452386abf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/teeckoo/gkit/releases/download/v0.13.0/gkit-x86_64-apple-darwin.tar.xz"
      sha256 "d3bea58fb9c8c10c2072f29f811e595902fc59f9dfa11cc4c488bb71760e9f85"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/teeckoo/gkit/releases/download/v0.13.0/gkit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5525a8e53651579f50c138ad3a0eb907ed3c01efc918a942d09b211eb967ae26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/teeckoo/gkit/releases/download/v0.13.0/gkit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "52aae2497e9f309417504618adfd0e8e4e99e064e0e8c4133faa60b1749855fd"
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
