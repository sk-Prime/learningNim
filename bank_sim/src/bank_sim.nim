import rdstdin
import strutils
import terminal
import strformat
#---------------------------CLASS BANK----------------------------------
echo "Trillion Bank"
var
    loggedName = ""
    loggedPass = 0
    loggedIndex = -1
type
    Account = object
        name : seq[string]
        password : seq[int]
        dollar : seq[int]
        
proc input(): (string, int) #outsider
proc colorEcho(color : string, text : string)
proc addAccount(acc : var Account): void =
    let (name, password) = input()
    if name != "" and loggedIndex == -1:
        acc.name.add(name)
        acc.password.add(password)
        while true:
            try:
                let money = strutils.parseInt(
                    rdstdin.readLineFromStdin("Initial ammount (dollar) : "))
                acc.dollar.add(money)
                break
            except:
                colorEcho("red","Invalid amount\n")
    else:
        colorEcho("red","Sign out first\n")
                
proc searchId(acc: Account, name : string, password: int): int =
    #return index of given name and password
    var index = -1
    for i in 0..<len(acc.name):
        if acc.name[i] == name and acc.password[i] == password:
            index = i
    return index

proc viewAccount(acc: Account): void =
    let (name, password) = input()
    if name != "":
        var index = searchId(acc, name, password)
        case index
            of -1:
                echo ""
                colorEcho("red", fmt"Account for {name} does not exist")
            else:
                stdout.write("Name   : ")
                colorEcho("green", acc.name[index])
                stdout.write("Dollar : ")
                colorEcho("green", $acc.dollar[index])
            
proc withdraw(acc : var Account, amount: int): void =
    let (name, password) = input()
    if name != "":
        let exists = searchId(acc, name, password)
        case exists
            of -1:
                colorEcho("red","\nmoney for you is forbidden | acc is not valid")
            else:
                let dollar = acc.dollar[exists]
                if amount>dollar:
                    echo ""
                    colorEcho("red",fmt"Moron! you have {dollar} dollar")
                else:
                    acc.dollar[exists] = dollar - amount
                    echo "\nhere is your ",amount," dollar"
                    echo "your current balance is ",dollar - amount," dollar"

proc deposit(acc : var Account, amount: int): void =
    let (name, password) = input()
    if name != "":
        let exists = searchId(acc, name, password)
        case exists
            of -1:
                colorEcho("red","\nwe don't take counterfeit money! big sorry | acc is not valid")
            else:
                acc.dollar[exists] = acc.dollar[exists] + amount
                echo "your current balance is ",acc.dollar[exists]," dollar"
            
#----------------------CLASS BANK END-----------------------------------

#----------------------INPUT HANDLER------------------------------------
proc input(): (string, int) =
    block INPUT:
        if loggedIndex == -1:
            var
                name = ""
                password = -1
            while true:
                let nameInp = rdstdin.readLineFromStdin("Type your name (c to close): ")
                case nameInp
                    of "":
                        colorEcho("red","invalid name\n")
                    of "c":
                        break INPUT
                    else:
                        name = nameInp
                        break
                        
            while true:
                try:
                    let passInp = strutils.parseInt(
                        rdstdin.readLineFromStdin("Type password : "))
                    password = passInp
                    break
                except:
                    colorEcho("red","invalid password\n")
            return (name, password)
        else:
            return (loggedName, loggedPass)
            
#---------------------------RUN-----------------------------------------
proc colorEcho(color : string, text : string): void =
    case color
        of "red":
            setForegroundColor(fgRed, bright = true)
            echo text
        of "magenta":
            setForegroundColor(fgMagenta, bright = true)
            stdout.write(text)
        of "green":
            setForegroundColor(fgGreen, bright = false)
            echo text
    resetAttributes()
    
when isMainModule:
    var accounts = Account()
    var loggedAs=""
    while true:
        if loggedIndex != -1:
            loggedAs = "Active ID : " & loggedName
        stdout.write("----------------------\n\nWhat do you want?(")
        colorEcho("magenta",loggedAs)
        stdout.write(")")
        echo ""
        var wantto = rdstdin.readLineFromStdin("type full word or first letter e.g add or a, about or ab\n\nadd, view, withdraw, deposit, about, login, sign out or exit : ")
        case wantto
            of "add", "a":
                echo "\nAdd Account\n"
                accounts.addAccount()
            of "view", "v":
                echo "\nView Account\n"
                accounts.viewAccount()
            of "withdraw", "w":
                echo "\nWithdraw wisely\n"
                try:
                    let amount = parseInt(rdstdin.readLineFromStdin("How much do you want to take : "))
                    accounts.withdraw(amount)
                except:
                    colorEcho("red","\ninvalid amount")
            of "deposit", "d":
                echo "\nDeposit for winter\n"
                try:
                    let amount = parseInt(rdstdin.readLineFromStdin("Amount you want to deposit : "))
                    accounts.deposit(amount)
                except:
                    colorEcho("red","\ninvalid amount")
            of "exit", "e":
                break
            of "about", "ab":
                echo "\n\nSimple Bank Account management program\nWritten in nim programing language\n\nBy Salim"
            of "login", "l":
                echo "\nLogin"
                let (name, password) = input()
                let index = searchId(accounts, name, password)
                case index
                    of -1:
                        colorEcho("red", "\ninvalid name or password")
                    else:
                        if loggedIndex != -1:
                            echo "\nID : " & loggedName & " is already active"
                        else:
                            loggedName = name
                            loggedIndex = index
                            loggedPass = password
                            echo "\nLogin Successful"
            of "sign out", "s", "signout":
                if loggedIndex != -1:
                    loggedIndex = -1
                    loggedAs    = ""
                    loggedName  = ""
                    loggedPass  = 0
                    echo "\nSuccessfuly signed out"
                else:
                    colorEcho("red", "\nno login occured")
            else:
                colorEcho("red","\nWrong input")
#https://paste.ofcode.org/rJtwDHXdkAqQjsXv2gcd4D

