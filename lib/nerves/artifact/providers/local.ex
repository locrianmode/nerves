defmodule Nerves.Artifact.Providers.Local do
  @moduledoc """
  Builds an artifact locally.

  This provider will only function on certain Linux host configurations
  """

  alias Nerves.Artifact
  alias Nerves.Artifact.Provider

  @behaviour Provider

  @doc """
  Builds an artifact locally.
  """
  @spec build(Nerves.Package.t(), Nerves.Package.t(), term) :: Provider.build_result()
  def build(pkg, toolchain, opts) do
    pkg.platform.build(pkg, toolchain, opts)
  end

  @doc """
  Builds an artifact locally.
  """
  @spec archive(Nerves.Package.t(), Nerves.Package.t(), term) :: Provider.archive_result()
  def archive(pkg, toolchain, opts) do
    pkg.platform.archive(pkg, toolchain, opts)
  end

  @doc """
  Builds an artifact locally.
  """
  @callback clean(package :: Nerves.Package.t()) :: Provider.clean_result()
  def clean(pkg) do
    pkg.platform.clean(pkg)
  end

  @doc """
  Connect to a system configuration sub-shell
  """
  @spec system_shell(Nerves.Package.t()) :: :ok
  def system_shell(pkg) do
    dest = Artifact.build_path(pkg)

    shell = System.get_env("SHELL") || "/bin/bash"

    script = Path.join(Nerves.Env.package(:nerves_system_br).path, "create-build.sh")
    platform_config = pkg.config[:platform_config][:defconfig]
    defconfig = Path.join("#{pkg.path}", platform_config)

    initial_input = [
      "echo Updating build directory.",
      "echo This will take a while if it is the first time...",
      "#{script} #{defconfig} #{dest} >/dev/null",
      "cd #{dest}"
    ]

    Mix.Nerves.Shell.open(shell, initial_input)
  end
end
