#* Imports
import subprocess
import sys
import os
import re
import getpass
import shlex

#* Functional
def apply (function, arguments):
    """Call FUNCTION with ARGUMENTS, return the result."""
    return function (*arguments)

def mapcar (func, lst):
    """Compatibility function for Python3.

    In Python2 `map' returns a list, as expected.  But in Python3
    `map' returns a map object that can be converted to a list.
    """
    return list (map (func, lst))

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

def flatten (seq):
    """Flatten a list of lists into a list."""
    return [item for sublist in seq for item in sublist]

def partition (n, seq):
    return [seq[i:i + n] for i in range (0, len (seq), n)]

def delete (element, lst):
    return [x for x in lst if x != element]

#* OS
def addpath (path):
    sys.path.append (path)

def user_login_name ():
    return getpass.getuser()

def eval (s):
    out = subprocess.check_output (["emacsclient", "-e", s])
    return out[:-1]

#* Files
def default_directory ():
    return os.getcwd ()

def cd (directory):
    os.chdir (expand_file_name (directory))

def expand_file_name (f, directory = None):
    if not directory:
        directory = os.getcwd ()
    if re.match ("^~", f):
        return os.path.expanduser (f)
    else:
        return os.path.realpath (os.path.join (directory, f))

def file_name_directory (f):
    return os.path.dirname (f)

def file_name_nondirectory (f):
    return os.path.basename (f)

def file_exists_p (f):
    return os.path.exists (f)

def file_directory_p (f):
    return os.path.isdir (f)

def abbreviate_file_name (f, d):
    m = re.match (d, f)
    if m:
        return f[m.end () + 1:]

def directory_files (d, full = False, match = False):
    fl = os.listdir (d)
    if match:
        fl = filter (lambda f:  None != string_match (match, f), fl)
    if full:
        fl = map (lambda f: expand_file_name (f, d), fl)
    return fl

def delete_file (f):
    return os.remove (f)

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
    return subprocess.check_output (shlex.split (cmd))

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

def re_filter (regex, seq):
    return filter (lambda s: re.search (regex, s), seq)

def re_seq (regex, s):
    return re.findall (regex, s)
