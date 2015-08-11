# Development Environment Compose (decompose)

Decompose is a templating framework to help developers easily create and switch environments. Decompose provides development environment templates, custom variables and commands.

"Don't decompose trying to manage various environments!"

## Requirements

Decompose is implemented in bash to avoid complex dependencies. However, Decompose does depend on a few tools.

The following is required:
- [bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29)
- [git](www.git-scm.com)
- [mo](https://github.com/tests-always-included/mo)
- common linux commands (which, echo, cat, mkdir, realpath, cp, find)

Decompose will try to detect missing dependencies when it is run.

### Installing Mo

Probably dependency which no one will have is 'mo'. Fortuately, 'mo' is easy to install. For most linux users, simply copy the 'mo' script into a `bin` directory and make it available in your $PATH variable.

Arch Linux users can [install 'mo' from the AUR](https://aur.archlinux.org/packages/mo-git/).

## Usage

```
$ decompose --help
decompose - Development Environment Compose

Core commands:

--init <git_url> <environment_name>
  Initialize an environment from a git URL and name
--update
  Update the current environment
--build
  Build project files from templates
--version
  Print version
--help
  This message

Environment commands:

hello_world
  Hello World command help
params
  Prints parameters
root_directory
  Prints the project root directory
```

### Init

Init will download and prepare an environment from and environment template. Environment templates are stored in git.

Example:
`decompose --init https://github.com/dmp1ce/decompose-hello-world.git hello_world`

### Update

Update will update the environment template default elements and processes. Update will not automatically update template files as they are intended to be changed during development.

Example:
`decompose --update`

### Build

Build will apply elements to the .mo template files. Custom elements can be created in the `.decompose/elements` file manually.

Example:
`decompose --build`

### Environment commands

Custom processes are created for each environment. These processes are located in the `.decompose/environment/processes` directory. Currently, the only way to create new processes is to modify the environment template. Custom processes are on the roadmap.

## Environment templates

Environment templates include:

- skeleton directory (`skel`), which includes a copy of all the files that will be create on `--init`
- `elements` file which contains all of the default settings for an environment
- `processes` file which contains all of the environment commands

See the [hello_world environment template](https://github.com/dmp1ce/decompose-hello-world) repository for an example of what is possible with the environment templates.

### Processes

Processes are defined in the `processes` file. Each command in the `processes` file needs to be included in the `DECOMPOSE_PROCESSES` array and needs to have a function with the same name as well as a `_help` function. Once these three things are complete the command can be seen in help and run from the command line.

Example:
```
#!/bin/bash
DECOMPOSE_PROCESSES=('hello_world')

hello_world() {
  echo "Hello World!"
}

hello_world_help() {
  cat <<HELP_EOF
  Hello World Help
  This is an example help file
  Notice the indentions
HELP_EOF
}
```

### Templates (.mo files)

Tempalates are located in the `skel` directory and copied to the projects root on `--init`. Templates follow a basic [mustache](https://mustache.github.io/) specification. Specifically, the templates are processed using [mo](https://github.com/tests-always-included/mo), a bash implementation of mustache.

Decompose will use `elements` to complete the template file variables.

Example:
```
$ cat hello_world.mo
Hello World!

Current environment is {{PROJECT_ENVIRONMENT}}

{{#PROJECT_CONDITION}}
PROJECT_CONTITION was true
{{/PROJECT_CONDITION}}
{{^PROJECT_CONDITION}}
PROJECT_CONTITION was false
{{/PROJECT_CONDITION}}

Actual value '{{PROJECT_CONDITION}}'

Default setting {{PROJECT_RANDOM_SETTING}}
```

## Vocabulary

To keep things fun, lets try to stick with a theme of natural decomposition

- Ecosphere is an index of environments
- Environments contain skeleton, processes, elements and templates
- Skeleton is the environment framework files
- .mo files are the template file or organism undergoing rigor (mo)rtis (the extension (.mo) is also the bash mustache extenstion)
- elements are the variables used by the .mo templates
- processes are the commands

Hence, organisms *decompose* in *environments* by *elements* and *processes* after rigor *mo*rtis until only the *skeleton* remains.
