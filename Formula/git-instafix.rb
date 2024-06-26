class GitInstafix < Formula
  desc "Apply staged git changes to an ancestor git commit.
"
  homepage "https://github.com/quodlibetor/git-instafix"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.7/git-instafix-aarch64-apple-darwin.tar.xz"
      sha256 "065a66d314436855a5358b5c8d51363be4c155e7a8c0ebdc7a994b02f402f464"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.7/git-instafix-x86_64-apple-darwin.tar.xz"
      sha256 "2e1bc584eed2e35bc7c1ef1f47b1d4290f2452645dfab3429ab17789256d37f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.7/git-instafix-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2ba98e0d47b461ef6e7f8e2418b35755e4955bad31814d001609d79cf69fcabe"
    end
  end

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}, "x86_64-unknown-linux-musl-dynamic": {}, "x86_64-unknown-linux-musl-static": {}}

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
      bin.install "git-instafix"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-instafix"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-instafix"
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
