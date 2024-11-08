class HydrangeaScreenMonitor < Formula
  include Language::Python::Virtualenv

  desc "For safely monitoring screens"
  homepage "https://github.com/Zeyu-Xie/Hydrangea-Screen-Monitor"
  url "https://github.com/Zeyu-Xie/Hydrangea-Screen-Monitor/archive/refs/tags/1.0.0.tar.gz"
  sha256 "da435431d0ab4465dc69791fb5074b4a9234b7107b6d032239c668a58a8dbbe1"
  license "MIT"

  depends_on "python@3.11"
  depends_on "sshpass"

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install "pyinstaller"
    venv.pip_install "macholib"
    venv.pip_install "altgraph"
    system libexec/"bin/pyinstaller",
      "--onefile",
      "--name", "hydrangea-screen-monitor",
      "--distpath=#{libexec}/bin",
      buildpath/"hydrangea-screen-monitor.py"
    bin.install libexec/"bin/hydrangea-screen-monitor"
  end

  test do
    assert_match "hydrangea-screen-monitor 1.0.0", shell_output("#{bin}/hydrangea-screen-monitor -v")
  end
end
