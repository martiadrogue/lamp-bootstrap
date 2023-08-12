# GUIDELINES

## Linter

Shell syntax should follow the [ShellCheck](https://www.shellcheck.net/) rules.

## File

Executables like `boostrap` should have no extension (strongly preferred) or
a .sh extension.

Libraries like `common.sh` must have a .sh extension and should not be
executable.

It is not necessary to know what language a program is written in when executing
it and shell doesn't require an extension so we prefer not to use one for
executables.

However, for libraries it's important to know what language it is and sometimes
there's a need to have similar libraries in different languages. This allows
library files with identical purposes but different languages to be identically
named except for the language-specific suffix.

## File Header

It's recommended to start each file with a top-level comment including a brief
overview of its contents.

A copyright notice and author information are optional.

```sh
#!/bin/bash
#
# Update Snap App Icons to Papirus theme.
# Copyright (c) 2023 MaExtensionrti Adrogue <marti.adrogue@gmail.com>
```

## Constants

Should be 'readonly', capitalized and with underscores to separate words.

```sh
# Constant
readonly PATH_TO_FILES='/some/path'
```

If we need to export the constant to the environment use 'declare -xr'.

```sh
# Set environment constant
declare -xr STAGE="dev"
```

It's OK to set a constant in getopts or based on a condition, but it
should be made readonly immediately afterwards.

```sh
VERBOSE='false'
while getopts 'v' flag; do
  case "${flag}" in
    v) VERBOSE='true' ;;
  esac
done
readonly VERBOSE
```

## Variables

Should be lower-case and with underscores to separate words.

```sh
# Variable
my_var='foo'
```

Ensure that local variables are only seen inside a function and its children by
using local when declaring them. This avoids polluting the global name space and
inadvertently setting variables that may have significance outside the function.

Declaration and assignment must be separate statements when the assignment value
is provided by a command substitution; as the 'local' builtin does not propagate
the exit code from the command substitution.

```sh
my_func2() {
  local name="$1"

  # Separate lines for declaration and assignment:
  local my_var
  my_var="$(my_func)" || return

  # DO NOT do this: $? contains the exit code of 'local', not my_func
  local my_var="$(my_func)"
  [[ $? -eq 0 ]] || return
}
```

### Functions

Should be lower-case and with underscores to separate words.

Braces must be on the same line as the function name and no space between the
function name and the parenthesis.

The keyword function is recommended.

```sh
function my_func() {
  ...
}
```

## Main Function

In order to easily find the start of the program, put the main program in a
function called main as the bottom most function. This provides consistency with
the rest of the code base as well as allowing you to define more variables as
local (which can't be done if the main code is not a function).

The last non-comment line in the file should be a call to main:
```sh
main "$@"
```
### Indentation

Use blank lines between blocks to improve readability. Indent 2 spaces. No tabs.

### Line Length and Long Strings

If you have to write strings that are longer than 80 characters, this should be
done with a here document or an embedded newline if possible. Literal strings
that have to be longer than 80 chars and can't sensibly be split are ok, but
it's strongly preferred to find a way to make it shorter.

```sh
# DO use 'here document's
cat <<END;
I am an exceptionally long
string.
END

# Embedded newlines are ok too
long_string="I am an exceptionally
  long string."
```

### Pipelines

If a pipeline all fits on one line, it should be on one line.

If not, it can be split at one pipe segment per line with the pipe on the
newline and a 2 space indent for the next section of the pipe. This applies to
a chain of commands combined using '|' as well as to logical compounds using
'||' and '&&'.

```sh
# All fits on one line
command1 | command2

# Long commands
command1 \
  | command2 \
  | command3 \
  | command4
```

### Loops

Loops in shell are a bit different, but we follow the same principles as with
braces when declaring functions. That is: ; then and ; do should be on the same
line as the if/for/while. else should be on its own line and closing statements
should be on their own line vertically aligned with the opening statement.

```sh
for dir in ${dirs_to_cleanup}; do
  if [[ -d "${dir}/${ORACLE_SID}" ]]; then
    log_date "Cleaning up old files in ${dir}/${ORACLE_SID}"
    rm "${dir}/${ORACLE_SID}/"*
    if [[ "$?" -ne 0 ]]; then
      error_message
    fi
  else
    mkdir -p "${dir}/${ORACLE_SID}"
    if [[ "$?" -ne 0 ]]; then
      error_message
    fi
  fi
done
```

### Case statement

The matching expressions are indented one level from the 'case' and 'esac'.
Multiline actions are indented another level with the pattern on a line on its
own, then the actions, then ;; also on a line of its own.
In general, there is no need to quote match expressions. Pattern expressions
should not be preceded by an open parenthesis. Avoid the ;& and ;;& notations.

```sh
case "${expression}" in
  a)
    variable="..."
    some_command "${variable}" "${other_expr}" ...
    ;;
  absolute)
    actions="relative"
    another_command "${actions}" "${other_expr}" ...
    ;;
  *)
    err "Unexpected expression '${expression}'"
    ;;
esac
```

Simple commands may be put on the same line as the pattern and ;; as long as the
expression remains readable. Use a space after the close parenthesis of the
pattern and another before the ;;.
This is often appropriate for single-letter option processing.

```sh
verbose='false'
aflag=''
bflag=''
files=''
while getopts 'abf:v' flag; do
  case "${flag}" in
    a) aflag='true' ;;
    b) bflag='true' ;;
    f) files="${OPTARG}" ;;
    v) verbose='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done
```
