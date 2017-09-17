defmodule Myapp.DistilleryPlugins do
  use Mix.Releases.Plugin
  
  def before_assembly(%Release{} = release, _opts) do
    info "This is executed just prior to assembling the release"
    with {_, 0} <- System.cmd("mix", ["phx.digest"]) do
      info "Digest complete"
      release
    end
  end

  def after_assembly(%Release{} = release, _opts) do
    # info "This is executed just after assembling, and just prior to packaging the release"
    release # or nil
  end

  def before_package(%Release{} = release, _opts) do
    # info "This is executed just before packaging the release"
    release # or nil
  end

  def after_package(%Release{} = release, _opts) do
    # info "This is executed just after packaging the release"
    release # or nil
  end

  def after_cleanup(_args, _opts) do
    # info "This is executed just after running cleanup"
    :ok # It doesn't matter what we return here
  end
end
