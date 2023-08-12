# LAMP BOOTSTRAP

[![license](https://img.shields.io/badge/license-MIT-red.svg?style=flat)](https://raw.githubusercontent.com/z017/shell-script-skeleton/master/LICENSE)

Install and config LAMP applications for a symfony project.

LAMP Bootstrap is used as a script to provision machines with required software
to run Symfony projects.

[Project Web](https://github.com/martiadrogue/lamp-bootstrap) · [Twitter](http://twitter.com/Mar7iAdrogue) . [Email](mailto:marti.adrogue@gmail.com)

## Features

* Build above [Shell Script Skeleton](https://github.com/z017/shell-script-skeleton)
* Create .desktop files from all installed snap applications
  * Replace the icon's name for its papirus name only if the script founds it

## Getting Started

Download the shell script from source:

```sh
$ git clone git://github.com/martiadrogue/replace-snap-icons.git
```

Afterwards, run the script:

```
$ cd lamp-boostrap
$ ./boostrap

USAGE:
  boostrap [options] <command>

  OPTIONS:
    --help, -h              Alias help command
    --version, -v           Alias version command
    --force                 Don't ask for confirmation
    --                      Denotes the end of the options.  Arguments after this
                            will be handled as parameters even if they start with
                            a '-'.

  COMMANDS:
    help                    Display detailed help
    version                 Print version information.

```

If you get an error like this one:

```sh
-bash: ./boostrap: Permission denied
```

Remember to make the script executable:

```sh
$ chmod +x boostrap
```
# License

Shell Script Skeleton is licensed under the MIT License (MIT). Please see [License File](https://raw.githubusercontent.com/z017/shell-script-skeleton/master/LICENSE) for more information.
