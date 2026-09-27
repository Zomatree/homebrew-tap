class Ermine < Formula
  desc "Native desktop client for Stoat chat"
  homepage "https://github.com/Zomatree/ermine"
  version "0.7.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Zomatree/ermine/releases/download/v0.7.2/Ermine-aarch64-apple-darwin.tar.xz"
    sha256 "e0a7048aba7645412620e09b8a64289c41931f694d0a3a1aebce75ebf9e8f526"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Zomatree/ermine/releases/download/v0.7.2/Ermine-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f9852db9c0e4ceb7c4e26b8a5fbc0362fe5dcc172865f9dec6b35dcd4e237391"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Zomatree/ermine/releases/download/v0.7.2/Ermine-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23ec72d166c114b10c644e450f26077b17644a6d4e9ca818563b998f5a4f0797"
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
