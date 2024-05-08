defmodule Plug.Timeout do
  @behaviour Plug

  @default_timeout 15_000

  @impl true
  def init(opts) do
    [timeout: Keyword.get(opts, :timeout, @default_timeout)]
  end

  @impl true
  def call(conn, opts) do
    timeout = Keyword.fetch!(opts, :timeout)
    monitor = setup_monitor(conn)

    case conn.private[:timeout_plug_timer_ref] do
      nil ->
        ref = Process.send_after(monitor, {:timeout, self()}, timeout)
        Plug.Conn.put_private(conn, :timeout_plug_timer_ref, ref)

      old_timer_ref ->
        Process.cancel_timer(old_timer_ref)
        ref = Process.send_after(monitor, {:timeout, self()}, timeout)
        Plug.Conn.put_private(conn, :timeout_plug_timer_ref, ref)
    end
  end

  defp setup_monitor(conn) do
    case conn.private[:timeout_plug_monitor_pid] do
      nil ->
        pid = Process.spawn_link(fn -> handle_info() end)
        Plug.Conn.put_private(conn, :timeout_plug_monitor_pid, pid)
        pid

      pid ->
        pid
    end
  end

  defp handle_info do
    receive do
      {:timeout, parent} ->
        :timeout

      s ->
        IO.inspect(s)
        handle_info()
    end
  end
end
