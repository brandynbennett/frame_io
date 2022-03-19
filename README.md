# FactEngine

Create and Query Facts

## Installation

[Install Elixir and Erlang](http://elixir-lang.org/install.html)

## Usage

Use the Mix task `mix fact_engine <file_path>` to execute `INPUT ` and `QUERY ` fact commands

### Example

```bash
mix fact_engine instructions/examples/3/in.txt
Compiling 1 file (.ex)
---
false
---
X: lucy
X: garfield
X: bowler_cat
---
FavoriteFood: lasagna
```

