#* Imports
import subprocess
import sys
import os
import re
import getpass
import shlex
from datetime import datetime

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

def cl_remove_if_not (pred, lst):
    return list (filter (pred, lst))

def cl_remove_if (pred, lst):
    return [x for x in lst if not pred(x)]

def cl_position_if (pred, lst):
    pos = 0
    for item in lst:
        if pred (item):
            return pos
        else:
            pos += 1

def cl_set_difference(lst1, lst2):
    s = set(lst2)
    return [x for x in lst1 if x not in s]

def cl_find_if (pred, lst):
    for item in lst:
        if pred (item):
            return item

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

#* Sys

def top_level ():
    f = sys._getframe ()
    while f.f_back:
        f = f.f_back
    return f

def crash ():
    tf = top_level ()
    f = sys._getframe ().f_back
    tf.f_globals["lnames"] = f.f_locals.keys ()
    for (k, v) in f.f_locals.items ():
        tf.f_globals[k] = v
    raise RuntimeError ("locals stored to globals")

#* OS
def addpath (path):
    sys.path.append (path)

def user_login_name ():
    return getpass.getuser()

def eval (s):
    out = subprocess.check_output (["emacsclient", "-e", s])
    return out[:-1]

def load_file (f):
    "Load a Python file into the REPL."
    exec (open (f).read(), globals ())

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

def file_name_sans_extension (f):
    return os.path.splitext (f)[0]

def file_name_directory (f):
    return os.path.dirname (f)

def file_name_nondirectory (f):
    return os.path.basename (f)

def file_exists_p (f):
    return os.path.exists (f)

def file_directory_p (f):
    return os.path.isdir (f)

def abbreviate_file_name (f, d):
    if not d[-1] == "/":
        d = d + "/"
    m = re.match (d, f)
    if m:
        return f[m.end ():]
    else:
        m = re.match (f, d)
        if m:
            return ".".join (["../"]* (d[m.end ():].count ("/") - 1))

def directory_files (d, full = False, match = False):
    fl = os.listdir (d)
    if match:
        fl = cl_remove_if_not (lambda f:  None != string_match (match, f), fl)
    if full:
        fl = mapcar (lambda f: expand_file_name (f, d), fl)
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
    return subprocess.check_output (["bash", "-c", cmd]).decode()

def shell_command_to_list (cmd):
    cmd_output = shell_command_to_string (cmd)
    return [s for s in cmd_output.split ("\n") if s]

def bash(cmd):
    if type(cmd) is list:
        cmd = "\n".join(cmd)
    print("Run: ", cmd)
    sys.stdout.flush()
    if hasattr(subprocess, "run"):
        return subprocess.run(["/bin/bash", "-e", "-c", cmd]).check_returncode()
    else:
        p = subprocess.Popen(["/bin/bash", "-e", "-c", cmd])
        return p.communicate()

#* String
def lformat (string):
    return string.format(**sys._getframe().f_back.f_locals)

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
    return list (filter (lambda s: re.search (regex, s), seq))

def re_seq (regex, s):
    return re.findall (regex, s)

def re_match(regex):
    return lambda s: re.search(regex, s)

def replace_regexp_in_string (regexp, rep, string):
    return re.sub (re.compile(regexp, re.MULTILINE), rep, string)

def spit(x, fname):
    with open(fname, "w") as f:
        if type(x) is str:
            f.write(x)
        elif type(x) is list and type(x[0]) is str:
            if re.search("\n", x[0]):
                sep = ""
            else:
                sep = "\n"
            f.write(sep.join(x))
        else:
            raise RuntimeError("Unexpected object", x)

def re_split(regex, lst):
    l1 = []
    l2 = []
    for x in lst:
        if re.search(regex, x):
            l1.append(x)
        else:
            l2.append(x)
    return (l1, l2)

#* Time
def timestamp():
    t = datetime.now()
    year = t.year
    month = t.month
    day = t.day
    hour = t.hour
    minute = t.minute
    dow = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][t.weekday()]
    return lformat("<{year}-{month:02d}-{day:02d} {dow} {hour:02d}:{minute:02d}>")
