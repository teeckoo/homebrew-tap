class Gkit < Formula
  desc "gkit — a transparent git/ssh toolkit: ssh keys, hooked clone, log-off check, stmb"
  homepage "https://github.com/teeckoo/gkit"
  version "0.11.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/teeckoo/gkit/releases/download/v0.11.1/gkit-aarch64-apple-darwin.tar.xz"
      sha256 "41ab14097809766db1d48c3b6b66ea62465966c15f68749f68d888993b9cb784"
    end
    if Hardware::CPU.intel?
      url "https://github.com/teeckoo/gkit/releases/download/v0.11.1/gkit-x86_64-apple-darwin.tar.xz"
      sha256 "5fde668e1da05d38b761a7f23fb33e9634e6fd9433e849f2a0ff9625846d695e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/teeckoo/gkit/releases/download/v0.11.1/gkit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b85faeb59374768a48ff0a1e2df27a404e411fad01bbcc3ff75bf94cdf5f42fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/teeckoo/gkit/releases/download/v0.11.1/gkit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "054b22d7dbc7bbc090aa02a24604522531a2673540265dbb8fb34d6180211985"
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
