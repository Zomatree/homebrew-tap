class Ermine < Formula
  desc "Native desktop client for Stoat chat"
  homepage "https://github.com/Zomatree/ermine"
  version "0.8.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Zomatree/ermine/releases/download/v0.8.0/Ermine-aarch64-apple-darwin.tar.xz"
    sha256 "46926536382c36a4594ea568a9ade79b329ea69e48c57fc38fa9a491af2c9a66"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Zomatree/ermine/releases/download/v0.8.0/Ermine-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dc3bd5bd2a11c9e99b832c97d763bb20949ecd044aafb9d731d996989078ad3a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Zomatree/ermine/releases/download/v0.8.0/Ermine-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1f136fa9fa777a1aaa0d9af57248bfd551c000e40a6ac1ffcf9522d1046f835d"
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
