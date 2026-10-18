class Ermine < Formula
  desc "Native desktop client for Stoat chat"
  homepage "https://github.com/Zomatree/ermine"
  version "0.9.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Zomatree/ermine/releases/download/v0.9.0/Ermine-aarch64-apple-darwin.tar.xz"
    sha256 "7193fbe96b9e399bbdd6c756febe53847f651bc36a1e7563f60acf57991f1196"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Zomatree/ermine/releases/download/v0.9.0/Ermine-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a2ba9c72cc53976700cfc380ca854e496dcef0bee2fa8268d76fc8a41645e223"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Zomatree/ermine/releases/download/v0.9.0/Ermine-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6936d7e2299b1198ee361e26a007a8a27af8e78ab5a433ed23031e477d874578"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "Ermine"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "Ermine"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "Ermine"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
