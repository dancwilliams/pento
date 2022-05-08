# lib/pento_web/live/wrong_live.ex

defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess.", answer: answer())}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
      It's <%= time() %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
      <% end %>
    </h2>
    """
  end

  def time() do
    DateTime.utc_now |> to_string
  end

  def answer() do
    :rand.uniform(10)
  end

  def handle_event("guess", %{"number" =>  guess}=data, socket) do

    {
      :noreply,
      assign(
        socket,
        message: new_message(guess, socket),
        score: new_score(guess, socket)
      )
    }
  end

  def new_message(guess, socket) do
    loss_message = "Your guess #{guess}. Wrong. Guess again."
    win_message = "You Win!"

    if guess == socket.assigns.answer do
      message = win_message
    else
      message = loss_message
    end
  end

  def new_score(guess, socket) do

    if guess == socket.assigns.answer do
      score = socket.assigns.score + 1
    else
      score = socket.assigns.score - 1
    end
  end

end
