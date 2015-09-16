# Features

- ignore missing help function
- Change .decompose/environment to be a submodule and initilize git on git init. Update will only update git submodule. Also remove .decompose-init file requirment.
- Create environment 'index' feature. 'decompose --show-ecosphere' to list all possible enivronments
- Allow for process subcommands with autocomplete and help Ex: 'decompose help process'
- Create decompose init script to run when 'decompose --init' is run. Allow it to prompt user to change the environment based on user input.
- Think about how elements and processes files should be auto genearted in project root and .decompose folder. What is private and what is not?

# Tests

- Verify that submodules get created on 'decompose --init'

# Documentation

- Document 'magic' elements