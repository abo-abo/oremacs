import subprocess
import os
import re

def shell_command_to_string (cmd):
    return subprocess.check_output (cmd.split (" "))

def file_name_directory (f):
    return os.path.dirname (f)

def file_exists_p (f):
    return os.path.exists (f)

def file_directory_p (f):
    return os.path.isdir (f)

def abbreviate_file_name (f, d):
    m = re.match (d, f)
    if m:
        return f[m.end () + 1:]

def expand_file_name (f, directory = None):
    if not directory:
        directory = os.getcwd ()
    return os.path.join (directory, f)

def directory_files (d):
    return os.listdir (d)
