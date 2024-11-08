class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.139",
      revision: "862827aef94d17c775c00854c4aa6a13c9e2d95b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc990e3c20e91df8b6ba94701a8a469b27a55f3fd1bb73623b9f7805b9e4cb1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc990e3c20e91df8b6ba94701a8a469b27a55f3fd1bb73623b9f7805b9e4cb1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc990e3c20e91df8b6ba94701a8a469b27a55f3fd1bb73623b9f7805b9e4cb1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "767e58d78f7ff23a526799b10d6efdeae049a8e707bb8a78391cf5a1a1bafb4b"
    sha256 cellar: :any_skip_relocation, ventura:       "767e58d78f7ff23a526799b10d6efdeae049a8e707bb8a78391cf5a1a1bafb4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2e8a50abf9d8e19f04c27fa75dd6514091440ed139461562d022104cb1223ab"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
