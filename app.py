import tkinter as tk
import re
import time

BIG_LETTERS = 60
NORMAL_LETTERS = 50
SMALL_LETTERS = 30

speed = 0.9
word_break = 150
capital_break = 200
sentence_break = 200
comma_break = 180
punct_break = 250
paragraph_break = 300
chapter_break = 1000

going = False

words = []
# The sentence to display
with open('words.txt', 'r') as file:
    sentences = ["<p>" if line == "\n" else line.strip() for line in file]
    words = [word for sentence in sentences for word in re.split(' |-|—', sentence)]

# The current word index
current_word_index = 0

def get_word(index):
    if index < 0:
        return ""
    if index >= len(words):
        return ""
    return words[index]

def break_word(word):
    if len(word) <= 2:
      return [(word, "black")]
    else:
      parts = [word[0], word[1:-1], word[-1]]
      return list(zip(parts, ["black", "gray", "black_sm"]))

def get_pause(word):
    if word == "<s>":
      return "", sentence_break
    elif word == "<p>":
      return "", paragraph_break
    elif word == "<c>":
      return "", chapter_break
    else:
      if word != "I" and re.search(r'[A-Z]', word):
        return word, capital_break
      elif re.search(r',$', word):
        return word, comma_break
      elif re.search(r'[.;]$', word):
        return word, sentence_break
      elif re.search(r'[?!]$', word):
        return word, punct_break
      else:
        return word, word_break


def display_word(index):
    word = get_word(index)
    print("displaying ind %s" % word)
    word, pause = get_pause(word)

    #time.sleep(pause * speed)

    word_minus = get_word(index-1)
    word_plus = get_word(index+1)
    text.configure(state='normal')  # temporarily make the text box editable
    text.delete("1.0", "end")  # delete all the existing text

    # insert newline characters before the word
    text.insert("1.0", "\n\n")

    text.insert("insert", word_minus + "               \n", "light")

    print(break_word(word))

    for part, tag in break_word(word):
       text.insert("insert", part, tag)

    text.insert("insert", "\n", "black") 

    text.insert("insert", "              " + word_plus + "\n", "light")

    # insert newline characters after the word
    text.insert("end", "\n\n")

    # reapply the centering to all the text
    text.tag_add("center", "1.0", "end")

    text.configure(state='disabled')  # make the text box read-only again

def go_to_previous_word(event=None):  # event is unused
    global current_word_index
    current_word_index = (current_word_index - 1) % len(words)  # wrap around to the end if necessary
    display_word(current_word_index)

def go_to_next_word(event=None):  # event is unused
    global current_word_index
    current_word_index = (current_word_index + 1) % len(words)  # wrap around to the start if necessary
    display_word(current_word_index)

def start_stop(event=None):
    global going
    going = not going
    if going:
      do_loop()

def speed_up(event=None):
    global speed
    speed = speed * 0.98

def speed_down(event=None):
    global speed
    speed = speed * 1.02

def do_loop():
    print("going %s" % going)
    if going:
      go_to_next_word()
      word, pause  = get_pause(get_word(current_word_index))
      pause = pause * speed
      print("pausing for: %s" % pause)
      root.after(int(pause), do_loop)



root = tk.Tk()
root.geometry('400x300')  # setting the window size

text = tk.Text(root, bg='white')  # setting the background to white
text.pack(expand=True, fill='both')  # making the Text widget fill the window

# Setting the font size to 20
text.tag_config("black", foreground="black", font=("Helvetica", BIG_LETTERS))
text.tag_config("black_sm", foreground="#555555", font=("Helvetica", NORMAL_LETTERS))
text.tag_config("gray", foreground="#777777", font=("Helvetica", NORMAL_LETTERS))
text.tag_config("light", foreground="#EEEEEE", font=("Helvetica", SMALL_LETTERS))

# Centering the text
text.tag_configure("center", justify='center')

# Display the initial word
display_word(current_word_index)

# Bind the left and right arrow keys to the appropriate functions
root.bind('<Left>', go_to_previous_word)
root.bind('<Right>', go_to_next_word)
root.bind('<Up>', speed_up)
root.bind('<Down>', speed_down)
root.bind('<space>', start_stop)
root.bind('<Escape>', lambda event: exit())

root.mainloop()



