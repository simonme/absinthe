defmodule Absinthe.Plugin do
  @moduledoc """
  Plugin Behaviour

  Plugins are an additional set of callbacks that can be used by module based
  middleware to run actions before and after resolution, as well as add additional
  phases to run after resolution
  """

  @type t :: module

  @doc """
  callback to setup the resolution accumulator prior to resolution.

  NOTE: This function is given the full accumulator. Namespacing is suggested to
  avoid conflicts.
  """
  @callback before_resolution(resolution_acc :: Document.Resolution.acc) :: Document.Resolution.acc

  @doc """
  callback to do something with the resolution accumulator after
  resolution.

  NOTE: This function is given the full accumulator. Namespacing is suggested to
  avoid conflicts.
  """
  @callback after_resolution(resolution_acc :: Document.Resolution.acc) :: Document.Resolution.acc

  @doc """
  callback used to specify additional phases to run.

  Plugins may require additional resolution phases to be run. This function should
  use values set in the resolution accumulator to determine
  whether or not additional phases are required.

  NOTE: This function is given the whole pipeline to be inserted after the current
  phase completes.
  """
  @callback pipeline(next_pipeline :: Absinthe.Pipeline.t, resolution_acc :: map) :: Absinthe.Pipeline.t


  @doc """
  Returns the list of default plugins.
  """
  def defaults() do
    [Absinthe.Middleware.Batch, Absinthe.Middleware.Async]
  end

  @doc false
  def pipeline(plugins, resolution_acc) do
    Enum.reduce(plugins, [], fn plugin, pipeline ->
      plugin.pipeline(pipeline, resolution_acc)
    end)
    |> Enum.dedup
    |> List.flatten
  end

end
