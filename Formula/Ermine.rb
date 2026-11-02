class Ermine < Formula
  desc "Native desktop client for Stoat chat"
  homepage "https://github.com/Zomatree/ermine"
  version "0.10.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Zomatree/ermine/releases/download/v0.10.0/Ermine-aarch64-apple-darwin.tar.xz"
    sha256 "095546c54116de996d022f7c9742cb197763f8cabfc31fb184a70ba44710a62d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Zomatree/ermine/releases/download/v0.10.0/Ermine-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "529306cfda0541bd8457a978778b8abb7e386f803d687b96c44de27f6bac9c73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Zomatree/ermine/releases/download/v0.10.0/Ermine-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9f3fc4fb9230210d141a3453c2524573c00ed92c98ff77713e7e4938f087a039"
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
