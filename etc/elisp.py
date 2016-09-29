import subprocess
import sys
import os
import re
import getpass

#* Functional
def cl_position_if (pred, lst):
    pos = 0
    for item in lst:
        if pred (item) is not None:
            return pos
        else:
            pos += 1

def mapconcat (func, lst, sep):
    if func:
        return sep.join (map (func, lst))
    else:
        return sep.join (lst)

#* OS
def addpath (path):
    sys.path.append (path)

def user_login_name ():
    return getpass.getuser()

#* File names
def default_directory ():
    return os.getcwd ()

def cd (directory):
    os.chdir (directory)

def expand_file_name (f, directory = None):
    if not directory:
        directory = os.getcwd ()
    return os.path.realpath (os.path.join (directory, f))

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

def directory_files (d):
    return os.listdir (d)

#* File read/write
def slurp (f):
    fh = open (f, 'r')
    res = fh.read ()
    fh.close ()
    return res

def barf (f, s):
    fh = open (f, 'w')
    fh.write (s)
    fh.close ()

#* Shell
def shell_command_to_string (cmd):
    return subprocess.check_output (cmd.split (" "))

def shell_command_to_list (cmd):
    cmd_output = shell_command_to_string (cmd)
    return [s for s in cmd_output.split ("\n") if s]

#* Regex
def string_match (regexp, string):
    global match_data
    m = re.search (regexp, string)
    if m:
        match_data = m
        return m.start ()

def match_string (group):
    global match_data
    return match_data.group (group)

def match_beginning (group):
    global match_data
    return match_data.start (group)

def match_end (group):
    global match_data
    return match_data.end (group)
