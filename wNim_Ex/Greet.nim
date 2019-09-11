import wnim/[wApp, wFrame, wStaticText, wPanel, wTextCtrl, wButton, wFont]

let app = App() #init

#main frame
let frame = Frame(title="Greeting", size=(300, 160), style=wDefaultFrameStyle)

#widget container
let panel = Panel(frame)

#it will show the name
let label = StaticText(panel, label= "Welcome")
#specifing font, size and type
label.font = Font(20, faceName= "consolas", weight= wFontWeightBold)
#resize the label border to fit the text
label.fit()

#take input from user
let textEntry = TextCtrl(panel, value="", style= wBorderSunken)
textEntry.suit()

#button control to show the message
let btn = Button(panel, label = "Greet")

#how the panel organize the widget inside of it.
proc layout() =
    panel.autolayout """
        H:|~[label]~|
        V:|-10-[label]
        H:|-10-[textentry]-10-|
        V:|-(label.height+15)-[textentry]
        H:|-10[btn]-10-|
        V:|-(textentry.height+label.height+30)-[btn]
    """

#when greet button get pressed this function will be called
proc buttonClick() =
    var inputedText= textEntry.getValue()
    case inputedText
        of "", " ":
            inputedText= "Nameless"
    label.label= "Welcome Mr. " & inputedText
    label.fit()
    layout()

#window size resize event callback
panel.wEvent_Size do ():
    layout() #layout will resize widgets accordingly

#button click event will call previously declared function
btn.wEvent_Button do():
    buttonClick()

#if enter key pressed inside the textCtrl, this will execute
textentry.wEvent_TextEnter do():
    buttonClick()

layout()
frame.show()
app.mainLoop()
