class Gkit < Formula
  desc "gkit — a transparent git/ssh toolkit: ssh keys, hooked clone, log-off check, stmb"
  homepage "https://github.com/teeckoo/gkit"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/teeckoo/gkit/releases/download/v0.4.0/gkit-aarch64-apple-darwin.tar.xz"
      sha256 "c41a9b1fdc2918a286b37bb26be2d93a845f889ce8fcd23fd29e3f93d39030c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/teeckoo/gkit/releases/download/v0.4.0/gkit-x86_64-apple-darwin.tar.xz"
      sha256 "8e2ae1601f2a423061faa46336c6768a6f2167200c024db0573bed161078d929"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/teeckoo/gkit/releases/download/v0.4.0/gkit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "384e02d92d166924258601b1dbc70e67b9d9da7c870aca7959da06fe531a8c02"
    end
    if Hardware::CPU.intel?
      url "https://github.com/teeckoo/gkit/releases/download/v0.4.0/gkit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6731d43c37e4db628309d75ed732e033bb4a6375203780c68b4135d66b67cf64"
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
