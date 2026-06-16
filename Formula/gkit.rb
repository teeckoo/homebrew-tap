class Gkit < Formula
  desc "gkit — a transparent git/ssh toolkit: ssh keys, hooked clone, log-off check, stmb"
  homepage "https://github.com/teeckoo/gkit"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/teeckoo/gkit/releases/download/v0.9.0/gkit-aarch64-apple-darwin.tar.xz"
      sha256 "b0735480b17015d5606719f8e9766a39615806ef105d4bac6c81be8e44a28e1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/teeckoo/gkit/releases/download/v0.9.0/gkit-x86_64-apple-darwin.tar.xz"
      sha256 "5770fd57db311c63d42353840c8fe8f511d41953bc50eaf05c3b38178c888377"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/teeckoo/gkit/releases/download/v0.9.0/gkit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "14266bc84c12abc3f3670e8c519efbe9cf08f56aea08c41dcd00d2f423a4240e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/teeckoo/gkit/releases/download/v0.9.0/gkit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "513429a5fc660a3bcbe6a7161591b585c89ea7f050f10d0afcaa193b3fde0bcc"
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
