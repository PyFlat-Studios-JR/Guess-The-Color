from tkinter import *
import random
master = Tk()

master.geometry('260x600+20+20')

w = Canvas(master, width=260, height = 500)
w.pack(expand=YES, fill= BOTH)
w.place(x = 0, y = 0)

farben = ["#8B4513", "yellow", "#C71585", "blue", "red", "green", "#696969", "#FF8C00"]
field = []
w.create_rectangle(220, 0, 260, 500, fill="black")
font = []
for i in range(1, 26):
    for j in range(1, 12):
        if i%2 == 0 and j%2 == 0:
            field.append(w.create_rectangle(j*20-17,i*20-17,j*20-2,i*20-2, fill="black"))
        if i%2 != 0 or j%2 !=0:
            w.create_rectangle(j*20-20,i*20-20,j*20,i*20, fill="black")


for i in range(1,13):
    font.append(w.create_text(220, i*39, text = 0, fill="white"))
    font.append(w.create_text(240, i*39, text = 0, fill="red"))
ctg = []
check = False
for i in range(0, 5):
    col = farben[random.randint(0, len(farben)-1)]
    while not check:
        if col in ctg:
            col = farben[random.randint(0, len(farben)-1)]
        else:
            ctg.append(col)
            check = True
    check = False

line = 0

b1 = Button(master, text = "A", bg = "white", command = lambda:[set_row(1)])
b1.place(x = 20, y = 510, width = 20, height = 20)
b2 = Button(master, text = "B", bg = "white", command = lambda:[set_row(2)])
b2.place(x = 60, y = 510, width = 20, height = 20)
b3 = Button(master, text = "C", bg = "white", command = lambda:[set_row(3)])
b3.place(x = 100, y = 510, width = 20, height = 20)
b4 = Button(master, text = "D", bg = "white", command = lambda:[set_row(4)])
b4.place(x = 140, y = 510, width = 20, height = 20)
b5 = Button(master, text = "E", bg = "white", command = lambda:[set_row(5)])
b5.place(x = 180, y = 510, width = 20, height = 20)

c1 = Button(master, text="", bg = farben[0], command = lambda:[set_col(0)])
c1.place(x = 12.94, y = 540, width = 20, height = 20)
c2 = Button(master, text="", bg = farben[1], command = lambda:[set_col(1)])
c2.place(x = 38.82, y = 540, width = 20, height = 20)
c3 = Button(master, text="", bg = farben[2], command = lambda:[set_col(2)])
c3.place(x = 64.7, y = 540, width = 20, height = 20)
c4 = Button(master, text="", bg = farben[3], command = lambda:[set_col(3)])
c4.place(x = 90.58, y = 540, width = 20, height = 20)
c5 = Button(master, text="", bg = farben[4], command = lambda:[set_col(4)])
c5.place(x = 116.46, y = 540, width = 20, height = 20)
c6 = Button(master, text="", bg = farben[5], command = lambda:[set_col(5)])
c6.place(x = 142.34, y = 540, width = 20, height = 20)
c7 = Button(master, text="", bg = farben[6], command = lambda:[set_col(6)])
c7.place(x = 168.22, y = 540, width = 20, height = 20)
c8 = Button(master, text="", bg = farben[7], command = lambda:[set_col(7)])
c8.place(x = 194.15, y = 540, width = 20, height = 20)

bs = Button(master, text="Submit", state = "disabled", bg = "black", fg = "white", command = lambda:[send()])
bs.place(x = 20, y = 570, width = 180, height = 20)
sel_row = 0
sel_col = 8
guess = [None, None, None, None, None]

def set_row(rw):
    global sel_row
    sel_row = rw
def set_col(cl):
    global sel_row, guess
    if farben[cl] in guess:
        guess[sel_row-1] = farben[cl]
        for i in range(0,5):
            if farben[cl] == guess[i]:
                guess[i] = None
                field_to_change = len(field)-1-(line*5)-(5-i-1)
                w.itemconfig(field[field_to_change], fill="black", width = 0)

    field_to_change = len(field)-1-(line*5)-(5-sel_row)
    w.itemconfig(field[field_to_change], fill=farben[cl], width = 0)
    guess[sel_row-1] = farben[cl]
    if not None in guess:
        bs.config(state="active")
        
    else:
        bs.config(state="disabled")
fr = 0
gr = 0
def send():
    global fr, gr, line, guess
    bs.config(state="disabled")
    for i in range(0,5):
        if guess[i] in ctg:
            fr += 1
            if guess[i] == ctg[i]:
                fr -= 1
                gr += 1
    w.itemconfig(font[len(font)-2-(line*2)], text = fr)
    w.itemconfig(font[len(font)-1-(line*2)], text = gr)
    if gr == 5:
        win()
    line += 1
    if line >= 12 and gr<5:
        lose()
    gr = 0
    fr = 0
    guess = [None, None, None, None, None]
def win():
    master.destroy() 
    master2 = Tk()
    master2.resizable(0,0)
    master2.geometry('220x50+20+20')
    w2 = Canvas(master2, width=220, height = 50)
    w2.pack(expand=YES, fill= BOTH)
    w2.place(x = 0, y = 0)
    w2.create_text(110, 20, text = "GEWONNEN", fill="green", font="Calibri 30")
    print(ctg)
def lose():
    master.destroy()
    master2 = Tk()
    master2.resizable(0,0)
    master2.geometry('220x50+20+20')
    w2 = Canvas(master2, width=220, height = 50)
    w2.pack(expand=YES, fill= BOTH)
    w2.place(x = 0, y = 0)
    w2.create_text(110, 20, text = "VERLOREN", fill="red", font="Calibri 30")
    print(ctg)
master.mainloop()
