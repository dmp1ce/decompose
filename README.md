# Development Environment Compose (decompose)

## Description

Decompose is a wrapper for the Docker Compose application. The purpose is to provide a development environment templates, variables and commands for running specific frameworks.

### Development Notes

Scratch pad for ideas about what decompose should become

#### decocompose will provide

- Evironment variable states such as (development, production) 
- Custom sub commands such as (build, backup, explore)
- A list of available framework templates such as (drupal, django, wordpress, rails, node, etc)
- A path for framework template updates
- Custom variables that can be used in template files.

#### proposed vocabulary

To keep things fun, lets try to stick with a theme of natural decomposition

- Index of framework templates <=> ecosphere (or world)
- framework template <=> environment
- template file <=> organism (the extension can be .org)
- variable used by the templates <=> element
- sub command <=> process

The idea is that *ecospheres* contain several different *environments*. In *environments* *organisms* exist which are broken down by the *elements*. Hence, we have *organisms* in *environments* which *decompose* from different *elemental* *processes*.
