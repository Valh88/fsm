defmodule Door do
  @behaviour :gen_statem

  def start_link do
    :gen_statem.start_link( __MODULE__,:ok,[] )
  end

  @impl :gen_statem
  def init(_), do: {:ok, :locked, nil}

  @impl :gen_statem
  def callback_mode, do: :handle_event_function

  @impl :gen_statem
  def handle_event({:call, from}, :unlock, :locked, data) do
    IO.inspect(data)
    {:next_state, :unlocked, data, [{:reply, from, {:ok, :unlocked}}]}
  end

  def handle_event({:call, from}, :lock, :unlocked, data) do
    {:next_state, :locked, data, [{:reply, from, {:ok, :locked}}]}
  end

  def handle_event({:call, from}, :open, :unlocked, data) do
    {:next_state, :opened, data, [{:reply, from, {:ok, :opened}}]}
  end

  def handle_event({:call, from}, :close, :opened, data) do
    {:next_state, :unlocked, data, [{:reply, from, {:ok, :unlocked}}]}
  end

  def handle_event({:call, from}, _event, _content, data) do
    {:keep_state, data, [{:reply, from, {:error, "invalid transition"}}]}
  end
end
