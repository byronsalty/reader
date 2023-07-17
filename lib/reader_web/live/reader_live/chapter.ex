defmodule ReaderWeb.ReaderLive.Chapter do
  use Phoenix.LiveView


  # alias Notes.Reports

  def x_handle_params(%{"book" => book, "chapter" => _chapter}, _uri, socket) do
    # some code

    text =
      if book == "moby" do
          "Call me Ishmael. Some years ago—never mind how long precisely—having
        little or no money in my purse, and nothing particular to interest me
        on shore, I thought I would sail about a little and see the watery part
        of the world. It is a way I have of driving off the spleen and
        regulating the circulation. Whenever I find myself growing grim about
        the mouth; whenever it is a damp, drizzly November in my soul; whenever
        I find myself involuntarily pausing before coffin warehouses, and
        bringing up the rear of every funeral I meet; and especially whenever
        my hypos get such an upper hand of me, that it requires a strong moral
        principle to prevent me from deliberately stepping into the street, and
        methodically knocking people’s hats off—then, I account it high time to
        get to sea as soon as I can. This is my substitute for pistol and ball.
        With a philosophical flourish Cato throws himself upon his sword; I
        quietly take to the ship. There is nothing surprising in this. If they
        but knew it, almost all men in their degree, some time or other,
        cherish very nearly the same feelings towards the ocean with me."
      else
        "_3 May. Bistritz._--Left Munich at 8:35 P. M., on 1st May, arriving at
        Vienna early next morning; should have arrived at 6:46, but train was an
        hour late. Buda-Pesth seems a wonderful place, from the glimpse which I
        got of it from the train and the little I could walk through the
        streets. I feared to go very far from the station, as we had arrived
        late and would start as near the correct time as possible. The
        impression I had was that we were leaving the West and entering the
        East; the most western of splendid bridges over the Danube, which is
        here of noble width and depth, took us among the traditions of Turkish
        rule.

        We left in pretty good time, and came after nightfall to Klausenburgh.
        Here I stopped for the night at the Hotel Royale. I had for dinner, or
        rather supper, a chicken done up some way with red pepper, which was
        very good but thirsty. (_Mem._, get recipe for Mina.) I asked the
        waiter, and he said it was called 'paprika hendl,' and that, as it was a
        national dish, I should be able to get it anywhere along the
        Carpathians. I found my smattering of German very useful here; indeed, I
        don't know how I should be able to get on without it."
      end

    IO.inspect(text, label: "text")

    forward = String.split(text, " ")

    last = ""
    [current | forward] = forward
    next = hd(forward)
    backward = []
    word_delay_ms = 130


    {:noreply, assign(
      socket,
      last: last,
      current: current,
      forward: forward,
      auto: false,
      word_delay_ms: word_delay_ms,
      wpm: calc_wpm(word_delay_ms),
      next: next,
      backward: backward
    )}
  end

  def mount(%{"book" => book, "chapter" => chapter} = params, _, socket) do

    IO.inspect(params, label: "params on mount")

    text =
      if book == "moby" do
          "Call me Ishmael. Some years ago—never mind how long precisely—having
        little or no money in my purse, and nothing particular to interest me
        on shore, I thought I would sail about a little and see the watery part
        of the world. It is a way I have of driving off the spleen and
        regulating the circulation. Whenever I find myself growing grim about
        the mouth; whenever it is a damp, drizzly November in my soul; whenever
        I find myself involuntarily pausing before coffin warehouses, and
        bringing up the rear of every funeral I meet; and especially whenever
        my hypos get such an upper hand of me, that it requires a strong moral
        principle to prevent me from deliberately stepping into the street, and
        methodically knocking people’s hats off—then, I account it high time to
        get to sea as soon as I can. This is my substitute for pistol and ball.
        With a philosophical flourish Cato throws himself upon his sword; I
        quietly take to the ship. There is nothing surprising in this. If they
        but knew it, almost all men in their degree, some time or other,
        cherish very nearly the same feelings towards the ocean with me."
      else
        "_3 May. Bistritz._--Left Munich at 8:35 P. M., on 1st May, arriving at
        Vienna early next morning; should have arrived at 6:46, but train was an
        hour late. Buda-Pesth seems a wonderful place, from the glimpse which I
        got of it from the train and the little I could walk through the
        streets. I feared to go very far from the station, as we had arrived
        late and would start as near the correct time as possible. The
        impression I had was that we were leaving the West and entering the
        East; the most western of splendid bridges over the Danube, which is
        here of noble width and depth, took us among the traditions of Turkish
        rule.

        We left in pretty good time, and came after nightfall to Klausenburgh.
        Here I stopped for the night at the Hotel Royale. I had for dinner, or
        rather supper, a chicken done up some way with red pepper, which was
        very good but thirsty. (_Mem._, get recipe for Mina.) I asked the
        waiter, and he said it was called 'paprika hendl,' and that, as it was a
        national dish, I should be able to get it anywhere along the
        Carpathians. I found my smattering of German very useful here; indeed, I
        don't know how I should be able to get on without it."

        # File.read!("static/assets/books/01.txt")
        path = Path.join(:code.priv_dir(:reader), "static/assets/books/#{book}/#{chapter}.txt")
        IO.inspect(path, label: "path")
        File.read!(path)
        # "foo bar baz"
      end

    IO.inspect(text, label: "text")

    forward = String.split(text, " ")

    last = ""
    [current | forward] = forward
    next = hd(forward)
    backward = []
    word_delay_ms = 130


    {:ok, assign(
      socket,
      last: last,
      current: current,
      forward: forward,
      auto: false,
      word_delay_ms: word_delay_ms,
      wpm: calc_wpm(word_delay_ms),
      next: next,
      backward: backward
    )}
  end

  def handle_event("next", _, socket) do
    {:noreply, next(socket)}
  end
  def handle_event("previous", _, socket) do
    {:noreply, previous(socket)}
  end
  def handle_event("up", _, socket) do
    {:noreply, faster(socket)}
  end
  def handle_event("down", _, socket) do
    {:noreply, slower(socket)}
  end
  def handle_event("space", _, socket) do
    {:noreply, start_stop(socket)}
  end

  def handle_event("press", %{"key" => "ArrowUp"}, socket) do
    {:noreply, faster(socket)}
  end
  def handle_event("press", %{"key" => "ArrowDown"}, socket) do
    {:noreply, slower(socket)}
  end
  def handle_event("press", %{"key" => "ArrowRight"}, socket) do
    {:noreply, next(socket)}
  end
  def handle_event("press", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, previous(socket)}
  end
  def handle_event("press", %{"key" => " "}, socket) do
    {:noreply, start_stop(socket)}
  end

  def handle_event("press", _, socket) do
    {:noreply, socket}
  end

  def handle_info(:loop, socket) do
    if socket.assigns.auto do

      pid = self()

      Task.start(fn ->
        # Do something asynchronously
        Process.sleep(socket.assigns.word_delay_ms)
        send(pid, :loop)
      end)

      {:noreply, next(socket)}
    else
      IO.inspect("no auto", label: "no auto")
      {:noreply, socket}
    end


  end

  defp start_stop(socket) do
    auto = not socket.assigns.auto
    IO.inspect(auto, label: "space")
    send(self(), :loop)

    assign(socket, auto: auto)
  end

  defp faster(socket) do
    word_delay_ms = trunc(socket.assigns.word_delay_ms * 0.98)
    assign(socket, word_delay_ms: word_delay_ms, wpm: calc_wpm(word_delay_ms))
  end

  defp slower(socket) do
    word_delay_ms = trunc(socket.assigns.word_delay_ms * 1.02)
    assign(socket, word_delay_ms: word_delay_ms, wpm: calc_wpm(word_delay_ms))
  end

  defp next(socket) do
    if Enum.count(socket.assigns.forward) > 0 do
      last = socket.assigns.current
      backward = [last | socket.assigns.backward]
      [current | forward] = socket.assigns.forward
      next =
        if Enum.count(forward) > 0 do
          hd(forward)
        else
          ""
        end

      assign(socket, last: last, current: current, next: next, forward: forward, backward: backward)
    else
      assign(socket, auto: false)
    end
  end
  defp previous(socket) do
    if Enum.count(socket.assigns.backward) > 0 do
      next = socket.assigns.current
      forward = [next | socket.assigns.forward]
      [current | backward] = socket.assigns.backward
      last =
        if Enum.count(backward) > 0 do
          hd(backward)
        else
          ""
        end
      assign(socket, last: last, current: current, next: next, forward: forward, backward: backward)
    else
      assign(socket, auto: false)
    end
  end

  defp calc_wpm(delay_ms) do
    trunc(60_000 / delay_ms)
  end
end
