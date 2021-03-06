defmodule Web.Html do
  @moduledoc """
  Provides the css and html for the web control page. Used in Web.Router
  """

  @compiled_at :calendar.universal_time
  @css File.read!(__DIR__ <> "/cultivatormobile.css")

  alias Locomotion.Locomotion

  def css do
    @css
  end

  def unstarted() do
  """
  <html>
  <head>
  <title>Cultivatormobile Control</title>
  <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
  <link rel="stylesheet" href="/cultivatormobile.css") %>">
  </head>
  <body>
  <div class="controller">
  <form action = "/start" method="post">
  <button type="submit">Start! </button>
  </form>
  </div>
  </head>
  """
  end

  def finished do
    time = GameState.finish_secs - GameState.start_secs
  """
  <html>
  <head>
  <title>Cultivatormobile Control</title>
  <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
  <link rel="stylesheet" href="/cultivatormobile.css") %>">
  </head>
  <body>
  <div class="controller">
  <h2>Your time is #{time} seconds</h2>
  <p>You are awesome!</p>
  <form action = "/reset" method="post">
  <button type="submit">Reset</button>
  </form>
  </div>
  </head>
  """
  end

  def control_page(message) do
    now = :erlang.universaltime
    """
    <html>
      <head>
        <title>Cultivatormobile Control</title>
        <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
        <link rel="stylesheet" href="/cultivatormobile.css") %>">
      </head>
  <body>
    <div class="controller">
      #{hit_header()}
      <div class="controller__left-controls">
        <table>
          <tr>
            <td colspan="3">
              <h2 class="controller__title">
                <i class="fa fa-arrows"></i> Movement</h2>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>
              <form action = "/forward" method="post">
                <button type="submit">
                &utrif;
                </button>
              </form>
            </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
              <form action = "/turn_left" method="post">
                <button type="submit">
                &ltrif;
                </button>
              </form>
            </td>
            <td>
              <form action = "/stop" method="post">
                <button type="submit">
                &otimes;
                </button>
              </form>
            </td>
            <td>
              <form action = "/turn_right" method="post">
                <button type="submit">
                &rtrif;
                </button>
              </form>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>
              <form action = "/back" method="post">
                <button type="submit">
                &dtrif;
                </button>
              </form>
            </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
          <td colspan="3">
              <form action = "/fire" method="post">
                 <button type="submit">
                    Fire!
                 </button>
               </form>
          </td>
          </tr>
          <tr>
            <td colspan="3">
              <form action = "/step_rate" method="post" class="controller__steps">
                <input type="number" name="step_rate" value="#{step_rate()}"></input>
                <input type="submit" value="Step rate"></input>
              </form>
            </td>
          </tr>
        </table>
      </div>
    </div>
    <div class="home-link">
      <a href="/">Home</a>
    </div>
    <p class="message">#{message}</p>
    <div class = "footer">
      <p>Page loaded at #{now |> format_date_time}</p>
      <p>Compiled at #{@compiled_at |> format_date_time}</p>
    </div>
    </body>
    </html>
    """
  end

  defp step_rate do
    case Locomotion.get_step_rate do
      {:error, :disabled_by_laser} -> "¯\(°_o)/¯"
      rate -> rate
    end
  end

  defp hit_header, do: hit_header(hit?())
  defp hit_header(true) do
    """
    <h2 class="hit">Aaaaaaaargh! I'm hit</h2>
    """
  end
  defp hit_header(_), do: ""

  defp hit? do
    case Locomotion.get_step_rate do
      {:error, :disabled_by_laser} -> true
      _ -> false
    end
  end


  defp format_date_time({{year, month, day}, {hour, minute, second}}) do
    "#{hour}:#{minute}:#{second} UTC on #{day} #{short_word_month(month)} #{year}"
  end

  defp short_word_month(1), do: "Jan"
  defp short_word_month(2), do: "Feb"
  defp short_word_month(3), do: "Mar"
  defp short_word_month(4), do: "Apr"
  defp short_word_month(5), do: "May"
  defp short_word_month(6), do: "Jun"
  defp short_word_month(7), do: "Jul"
  defp short_word_month(8), do: "Aug"
  defp short_word_month(9), do: "Sep"
  defp short_word_month(10), do: "Oct"
  defp short_word_month(11), do: "Nov"
  defp short_word_month(12), do: "Dec"
end
