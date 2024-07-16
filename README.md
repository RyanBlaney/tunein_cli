# TuneIn CLI

TuneIn CLI is a command-line interface for playing TuneIn radio stations. It allows you to search for radio stations and play them directly from the terminal.

## Installation

**Rename and Copy Executable**:
    ```sh
    ./linux_install.sh
    ```

This will build the project and copy the executable to `~/.local/bin/tunein_cli`.

## Build

To build the TuneIn CLI project, you need to have OCaml, Dune, and the required libraries installed. Follow these steps to build the project:

1. **Clone the Repository**:
    ```sh
    git clone git@github.com:RyanBlaney/tunein_cli.git
    cd tunein_cli
    ```

2. **Build the Project**:
    ```sh
    dune build
    ```

3. **Rename and Copy Executable**:
    ```sh
    ./linux_install.sh
    ```

This will build the project and copy the executable to `~/.local/bin/tunein_cli`.

## Usage

To use TuneIn CLI, simply run the executable with a search pattern for the radio station you want to play. For example:

```sh
tunein_cli "80s Rock"

