# Copyright 2017 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Rules to run a command inside a container, and either commit the result
to new container image, or extract specified targets to a directory on
the host machine.
"""

workspace(name = "base_images_docker")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "bazel_skylib",
    remote = "https://github.com/bazelbuild/bazel-skylib.git",
    tag = "0.6.0",
)

# Docker rules.
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "fe519e726201215ca3059223fb5b4181e97fa0d8efa33be382bef64d0bc43248",
    strip_prefix = "rules_docker-0475563f497ca8104bde290e64a3b39e2428f042",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/0475563f497ca8104bde290e64a3b39e2428f042.tar.gz"],
)
 # Register the docker toolchain type
register_toolchains(
    # Register the default docker toolchain that expects the 'docker'
    # executable to be in the PATH
    "@io_bazel_rules_docker//toolchains/docker:default_linux_toolchain",
    "@io_bazel_rules_docker//toolchains/docker:default_windows_toolchain",
    "@io_bazel_rules_docker//toolchains/docker:default_osx_toolchain",
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    docker_repositories = "repositories",
)
docker_repositories()


load(
    "@io_bazel_rules_docker//docker:docker.bzl",
    "docker_pull",
)


git_repository(
    name = "structure_test",
    commit = "6d872049813aa2c4887f561f798ea753ffe2ab68",
    remote = "https://github.com/GoogleCloudPlatform/container-structure-test.git",
)

git_repository(
    name = "runtimes_common",
    commit = "85b0acbf902e468ae0ffa00d8c236007f0b00ad5",
    remote = "https://github.com/GoogleCloudPlatform/runtimes-common.git",
)

http_archive(
    name = "docker_credential_gcr",
    build_file_content = """package(default_visibility = ["//visibility:public"])
exports_files(["docker-credential-gcr"])""",
    sha256 = "3f02de988d69dc9c8d242b02cc10d4beb6bab151e31d63cb6af09dd604f75fce",
    type = "tar.gz",
    url = "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v1.4.3/docker-credential-gcr_linux_amd64-1.4.3.tar.gz",
)

git_repository(
    name = "subpar",
    commit = "07ff5feb7c7b113eea593eb6ec50b51099cf0261",
    remote = "https://github.com/google/subpar",
)

docker_pull(
    name = "debian_base",
    digest = "sha256:00109fa40230a081f5ecffe0e814725042ff62a03e2d1eae0563f1f82eaeae9b",
    registry = "gcr.io",
    repository = "google-appengine/debian9",
)

git_repository(
    name = "distroless",
    commit = "a4fd5de337e31911aeee2ad5248284cebeb6a6f4",
    remote = "https://github.com/GoogleContainerTools/distroless.git",
)

load(
    "@distroless//package_manager:package_manager.bzl",
    "package_manager_repositories",
)

load(
    "@distroless//package_manager:dpkg.bzl",
    "dpkg_list",
    "dpkg_src",
)

package_manager_repositories()

# The Debian snapshot datetime to use. See http://snapshot.debian.org/ for more information.
DEB_SNAPSHOT = "20190507T102924Z"

dpkg_src(
    name = "debian_stretch",
    arch = "amd64",
    distro = "jessie",
    sha256 = "7240a1c6ce11c3658d001261e77797818e610f7da6c2fb1f98a24fdbf4e8d84c",
    snapshot = DEB_SNAPSHOT,
    url = "http://snapshot.debian.org/archive",
)

# These are needed to install debootstrap.
dpkg_list(
    name = "package_bundle",
    packages = [
        "ca-certificates",
        "debootstrap",
        "libffi6",
        "libgmp10",
        "libgnutls-deb0-28",
        "libhogweed2",
        "libicu52",
        "libidn11",
        "libnettle4",
        "libp11-kit0",
        "libpsl0",
        "libtasn1-6",
        "wget",
    ],
    sources = [
        "@debian_stretch//file:Packages.json",
    ],
)

http_archive(
    name = "io_bazel_rules_go",
    urls = ["https://github.com/bazelbuild/rules_go/releases/download/0.18.3/rules_go-0.18.3.tar.gz"],
    sha256 = "86ae934bd4c43b99893fc64be9d9fc684b81461581df7ea8fc291c816f5ee8c5",
)

http_archive(
    name = "bazel_gazelle",
    urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/0.17.0/bazel-gazelle-0.17.0.tar.gz"],
    sha256 = "3c681998538231a2d24d0c07ed5a7658cb72bfb5fd4bf9911157c0e9ac6a2687",
)

load("@io_bazel_rules_go//go:deps.bzl", "go_rules_dependencies", "go_register_toolchains", "go_download_sdk")

go_rules_dependencies()

go_register_toolchains()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()


go_download_sdk(
    name = "go_sdk",
    sdks = {
        "linux_amd64":   ("go1.11.4.linux-amd64.tar.gz",
            "fb26c30e6a04ad937bbc657a1b5bba92f80096af1e8ee6da6430c045a8db3a5b"),
        "darwin_amd64":      ("go1.11.4.darwin-amd64.tar.gz",
            "48ea987fb610894b3108ecf42e7a4fd1c1e3eabcaeb570e388c75af1f1375f80"),
    },
)

go_rules_dependencies()

go_register_toolchains()

UBUNTU_MAP = {
   "16_0_4": {
        "sha256": "fd9e05a2b68f63eaf4cc25033d2cb0589882c24397d4cf2e5068c4049cc1763e",
        "url": "https://storage.googleapis.com/ubuntu_tar/20190425/ubuntu-xenial-core-cloudimg-amd64-root.tar.gz",
    },
    "18_0_4": {
        "sha256": "65f7b277d131706107ba41d69468e31b0767420a01c8e5dec5ed9f15ff78fd9e",
        "url": "https://storage.googleapis.com/ubuntu_tar/20190408/ubuntu-bionic-core-cloudimg-amd64-root.tar.gz",
    },
}

[http_file(
    name = "ubuntu_%s_tar_download" % version,
    sha256 = map["sha256"],
    urls = [map["url"]],
) for version, map in UBUNTU_MAP.items()]

http_file(
    name = "bazel_gpg",
    sha256 = "30af2ca7abfb65987cd61802ca6e352aadc6129dfb5bfc9c81f16617bc3a4416",
    urls = ["https://bazel.build/bazel-release.pub.gpg"],
)

http_file(
    name = "launchpad_openjdk_gpg",
    sha256 = "54b6274820df34a936ccc6f5cb725a9b7bb46075db7faf0ef7e2d86452fa09fd",
    urls = ["http://keyserver.ubuntu.com/pks/lookup?op=get&fingerprint=on&search=0xEB9B1D8886F44E2A"],
)

