defmodule SigrokViewer.TcpServer do
  use GenServer

  def start_link(_args \\ []) do
    ip = Application.get_env(:tcp_server, :ip, {0, 0, 0, 0})
    port = Application.get_env(:tcp_server, :port, 5555)
    GenServer.start_link(__MODULE__, [ip, port], [])
  end

  def init([ip, port]) do
    IO.puts("starting")
    GenServer.cast(self, :listen)
    {:ok, %{ip: ip, port: port, socket: nil}}
  end

  def handle_cast(:listen, %{ip: ip, port: port} = state) do
    IO.puts("listening")
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, {:packet, 0}, {:active, true}, {:ip, ip}])
    GenServer.cast(self, :accept)

    {:noreply, %{ state | socket: socket}}
  end

  def handle_cast(:accept, state) do
    IO.puts("accept")
    {:ok, _conn} = :gen_tcp.accept(state.socket)
    {:noreply, state}
  end

  def handle_info({:tcp, socket, packet}, state) do
    IO.inspect(packet, label: "incoming packet")
    :gen_tcp.send(socket, packet)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, state) do
    IO.puts("tcp connection closed -> #{inspect socket}")
    GenServer.cast(self, :accept)
    {:noreply, state}
  end

  def handle_info({:tcp_error, socket, reason}, state) do
    IO.puts("tcp connection errored: #{inspect reason}")
    GenServer.cast(self, :accept)
    {:noreply, state}
  end
end
