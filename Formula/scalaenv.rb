class Scalaenv < Formula
  desc "Command-line tool to manage Scala environments"
  homepage "https://github.com/scalaenv/scalaenv"
  url "https://github.com/scalaenv/scalaenv/archive/version/0.1.8.tar.gz"
  sha256 "daa785c04064df0e3e2e7b9581e0ee791b0adddd16bf6e8fbb8d4a2839cdc0b3"
  license "MIT"
  head "https://github.com/scalaenv/scalaenv.git"

  bottle :unneeded

  def install
    inreplace "libexec/scalaenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    %w[scalaenv-install scalaenv-uninstall scala-build].each do |cmd|
      bin.install_symlink "#{prefix}/default-plugins/scala-install/bin/#{cmd}"
    end
  end

  def post_install
    var_lib = HOMEBREW_PREFIX/"var/lib/scalaenv"
    %w[plugins versions].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end

    (var_lib/"plugins").install_symlink "#{prefix}/default-plugins/scala-install"
  end

  test do
    shell_output("eval \"$(#{bin}/scalaenv init -)\" && scalaenv versions")
  end
end
