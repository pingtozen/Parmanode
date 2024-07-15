import subprocess
from config.variables_f import *
from tools.system_f import *
from tools.screen_f import *

def format_drive(drive_letter=None, file_system='NFTS', label="parmanode"):
    try:
        drive = f"{drive_letter}:" if not drive_letter.endswith(':') else drive_letter
        command = ['format', drive, '/fs:' + file_system, '/v:', label, '/q' ]
        return True
    except:
        return False

def detect_drive():
    
    set_terminal()
    input(f"""{orange}    Please make sure the drive you want to use with Parmanode
    is{cyan} DISCONNECTED{orange}. Then hit <enter>.""")
    #before_disks = set(get_all_disks)
    input(f"""{orange}    Now go ahead and connect the drive, wait a few seconds, then
    hit <enter>""")
    get_all_disks()
     
    return True
    
# def get_all_disks():
#     command = 'powershell -Command "Get-Disk | Format-List -Property FriendlyName,Size,Path"'
#     result = subprocess.run(command, capture_output=True, text=True, shell=True) 
#     disk_info = result.stdout.strip().splitlines()
#     tmpo = config(tmp)
#     for line in disk_info: 
#         tmpo.add(line)
#         print("...", line)
#     input("end get all disks")

def get_all_disks():
    import subprocess
    tmpo.truncate()
    diskpart_commands = """list disk"""
    tmpo.add(diskpart_commands)

    diskpart_script_path = str(tmpo)
    result = subprocess.run(['diskpart', '/s', diskpart_script_path], capture_output=True, text=True, shell=True).stdout.strip().split('\n')