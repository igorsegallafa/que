defmodule Que.Persistence do
  @moduledoc """
  Provides a high-level API to interact with Jobs in Database

  This module is a behaviour that delegates calls to the specified
  adapter. It has been designed in a way that it's easy to write
  custom adapters for other databases or stores like Redis, even
  though there are no current plans on supporting anything other
  than `Mnesia`.
  """


  ## Adapter to delegate all methods to
  def get_adapter(), do: Application.get_env(:que, :persistence_adapter, Que.Persistence.Mnesia)

  @doc """
  Finds a `Que.Job` from the database.

  Returns the a Job struct if it's found, otherwise `nil`.
  """
  @callback find(id :: integer) :: Que.Job.t | nil
  def find(id), do: get_adapter().find(id)




  @doc """
  Deletes a `Que.Job` from the database.
  """
  @callback destroy(id :: integer) :: :ok | no_return
  def destroy(id), do: get_adapter().destroy(id)




  @doc """
  Inserts a `Que.Job` into the database.

  Returns the same Job struct with the `id` value set
  """
  @callback insert(job :: Que.Job.t) :: Que.Job.t
  def insert(job), do: get_adapter().insert(job)




  @doc """
  Updates an existing `Que.Job` in the database.

  This methods finds the job to update by the given
  job's id. If no job with the given id exists, it is
  inserted as-is. If the id of the given job is nil,
  it's still inserted and a valid id is assigned.

  Returns the updated job.
  """
  @callback update(job :: Que.Job.t) :: Que.Job.t
  def update(job), do: get_adapter().update(job)




  @doc """
  Returns all `Que.Job`s in the database.
  """
  @callback all :: list(Que.Job.t)
  def all, do: get_adapter().all




  @doc """
  Returns all `Que.Job`s for the given worker.
  """
  @callback all(worker :: Que.Worker.t) :: list(Que.Job.t)
  def all(worker), do: get_adapter().all(worker)




  @doc """
  Returns completed `Que.Job`s from the database.
  """
  @callback completed :: list(Que.Job.t)
  def completed, do: get_adapter().completed




  @doc """
  Returns completed `Que.Job`s for the given worker.
  """
  @callback completed(worker :: Que.Worker.t) :: list(Que.Job.t)
  def completed(worker), do: get_adapter().completed(worker)




  @doc """
  Returns incomplete `Que.Job`s from the database.

  This includes all Jobs whose status is either
  `:queued` or `:started` but not `:failed`.
  """
  @callback incomplete :: list(Que.Job.t)
  def incomplete, do: get_adapter().incomplete




  @doc """
  Returns incomplete `Que.Job`s for the given worker.
  """
  @callback incomplete(worker :: Que.Worker.t) :: list(Que.Job.t)
  def incomplete(worker), do: get_adapter().incomplete(worker)




  @doc """
  Returns failed `Que.Job`s from the database.
  """
  @callback failed :: list(Que.Job.t)
  def failed, do: get_adapter().failed




  @doc """
  Returns failed `Que.Job`s for the given worker.
  """
  @callback failed(worker :: Que.Worker.t) :: list(Que.Job.t)
  def failed(worker), do: get_adapter().failed(worker)




  @doc """
  Makes sure that the Database is ready to be used.

  This is called when the Que application, specifically
  `Que.Server`, starts to make sure that a database exists
  and is ready to be used.
  """
  @callback initialize :: :ok | :error
  def initialize, do: get_adapter().initialize




  # Macro so future adapters `use` this module
  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)
    end
  end

end
