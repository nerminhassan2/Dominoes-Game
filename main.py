from pyswip import Prolog, Atom
from tkinter import *


def UninformedSearch():
    board_size = entry1.get()
    bomb_positions = entry2.get()
    board_row = board_size[0]
    board_col = board_size[2]
    bomb1_row = bomb_positions[0]
    bomb1_col = bomb_positions[2]
    bomb2_row = bomb_positions[4]
    bomb2_col = bomb_positions[6]
    prolog = Prolog()
    prolog.consult("search.pl")
    query = prolog.query(
        "game({},{},{},{},{},{},X)".format(board_row, board_col, bomb1_row, bomb1_col, bomb2_row, bomb2_col))
    for solution in query:
        if not solution['X']:
            text.insert(END, "NO Solution")
        else:
            for j in range(len(solution['X'])):
                old_list = solution['X'][j]
                for sublist in old_list:
                    for i in range(len(sublist)):
                        if isinstance(sublist[i], Atom) and str(sublist[i]) == '235525':
                            sublist[i] = '#'
                        text.insert(END, sublist[i])
                    text.insert(END, '\n')
                text.insert(END, '\n')


def delete():
    text.delete("1.0", "end")


def InformedSearch():
    board_size = entry1.get()
    bomb_positions = entry2.get()
    board_row = board_size[0]
    board_col = board_size[2]
    bomb1_row = bomb_positions[0]
    bomb1_col = bomb_positions[2]
    bomb2_row = bomb_positions[4]
    bomb2_col = bomb_positions[6]
    prolog = Prolog()
    prolog.consult("search.pl")
    query = prolog.query(
        "game1({},{},{},{},{},{},X,R)".format(board_row, board_col, bomb1_row, bomb1_col, bomb2_row, bomb2_col))
    check = False
    for solution in query:
        text.insert(END, solution['R'])
        text.insert(END, " is maximum number of dominoes that can be placed.")
        text.insert(END, '\n')
        for sublist in solution['X']:
            check = True
            for i in range(len(sublist)):
                if isinstance(sublist[i], Atom) and str(sublist[i]) == '235525':
                    sublist[i] = '#'
                text.insert(END, sublist[i])
            text.insert(END, '\n')
        text.insert(END, '\n')
    if len(list(query)) == 0 and not check:
        text.insert(END, "NO Solution")


root = Tk()
root.title("Dominoes Puzzle Solver")
root.geometry("400x400")

label1 = Label(root, text="Enter board size (MxN):", justify="left")
label1.config(bg="gray51")
label1.pack(pady=5, padx=20, side=TOP, anchor="w")
entry1 = Entry(root)
entry1.pack(pady=5, padx=20, side=TOP, anchor="w")

label2 = Label(root, text="Enter bomb positions (comma separated):", justify="left")
label2.config(bg="gray51")
label2.pack(pady=5, padx=20, side=TOP, anchor="w")
entry2 = Entry(root)
entry2.pack(pady=5, padx=20, side=TOP, anchor="w")

button_frame = Frame(root)
button_frame.pack(padx=20, side=TOP, anchor="w")

button1 = Button(button_frame, text="Uninformed Search", command=UninformedSearch, justify="left")
button1.config(bg="gray51")
button1.pack(side=LEFT, padx=10, pady=10)

button2 = Button(button_frame, text="Informed Search", command=InformedSearch, justify="left")
button2.config(bg="gray51")
button2.pack(side=LEFT, padx=10, pady=10)
text = Text(root, width=44, height=15)
clear_button = Button(button_frame, text="Clear", command=delete, justify="left")
clear_button.config(bg="gray51")
clear_button.pack(side=LEFT, padx=10, pady=10)

text.pack(pady=10)

root.mainloop()
