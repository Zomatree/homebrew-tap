class Ermine < Formula
  desc "Native desktop client for Stoat chat"
  homepage "https://github.com/Zomatree/ermine"
  version "0.7.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Zomatree/ermine/releases/download/v0.7.0/Ermine-aarch64-apple-darwin.tar.xz"
    sha256 "0cd9f5eeec8494754075aed2440046002a73980d00611c1408b5075a0aecf7a2"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Zomatree/ermine/releases/download/v0.7.0/Ermine-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3dd275f092d55fa6cf1bdbc874da38bace73d60179a32134e8ebb20be695793b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Zomatree/ermine/releases/download/v0.7.0/Ermine-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "565d1e7100c0c9f3b62350accad4641ca3715d7a4f4cfa11b7c4ba9370542245"
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
