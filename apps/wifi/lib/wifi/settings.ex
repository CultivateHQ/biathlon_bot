defmodule Wifi.Settings do
  require Logger

  def read_settings(file) do
    with {:ok, binary} <- File.read(file),
         {ssid, secret} <- decode_file_contents(binary) do
      Keyword.merge(default_settings(), ssid: ssid, psk: secret)

    else
      {:error, :enoent} ->
        # Not been set - it's fine
        default_settings()

      other ->
        Logger.error "Unexpected problem reading WiFi settings file: #{inspect(other)}"
        default_settings()
    end
  end

  def set(file, settings = {_ssid, _secret}) do
    File.write file, :erlang.term_to_binary(settings)
  end

  defp default_settings do
    Application.fetch_env!(:wifi, :settings)
  end

  defp decode_file_contents(binary) do
    try do
      :erlang.binary_to_term(binary)
    rescue
      ArgumentError ->
        "Corrupt file"
    end
  end
end
