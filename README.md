# Development Environment Compose (decompose)

## Description

Decompose is a templating framework to help developers switch environments. Decompose provides development environment templates, custom variables and commands.

"Don't decompose trying to manage various environments!"

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
- template file <=> organism undergoing rigor (mo)rtis (the extension can be .mo which is the extension for bash mustache (mo))
- variable used by the templates <=> element
- sub command <=> process

The idea is that *ecospheres* contain several different *environments*. In *environments* *organisms* exist which are broken down by the *elements*. Hence, we have *organisms* in *environments* which *decompose* from different *elemental* *processes*.
