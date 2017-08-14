defmodule WifiTest do
  use ExUnit.Case
  doctest Wifi

  test "greets the world" do
    assert Wifi.hello() == :world
  end
end
