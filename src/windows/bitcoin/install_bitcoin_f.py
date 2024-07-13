from config.variables_f import *
from tools.files_f import download 
from tools.files_f import * 
from tools.debugging_f import *
from tools.screen_f import *
from bitcoin.bitcoin_functions_f import *
import threading, time
from datetime import date


def install_bitcoin():

    set_terminal()
    print(f"{green}Bitcoin will be downloading in the background...")
    time.sleep(2.5)

    threading.Thread(target=download_bitcoin).start() #check download_bitcoin_finished global variable

    if not choose_drive():
        date = date.today().strftime("%d-%m-%y")
        dbo.write(f"{date}: Bitcoin choose_drive exited.")
        return 1

    if not format_external_drive():
        dbo.write(f"{date}: Bitcoin format_external drive exited.")
        return 1

def format_external_drive():
    set_terminal()
    print(f"""{cyan}    Please make sure the external drive you want to use for
    Bitcoin is connected.""")
    #get connected drives