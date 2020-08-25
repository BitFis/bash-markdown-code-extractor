# Bash Scripts

Those scripts should help setting things up and prepare the test environment.

## Test Scripts

For script quality, [bats](https://github.com/sstephenson/bats) was used to test
the scripts, it will mock the calls to the actual programs and just tests that the
scripts du what they should by checking input and the external calls. Running the
test scripts will not change any state on the machine.

To run the test, [bats needs to be installed](https://github.com/sstephenson/bats#installing-bats-from-source).

```bash
git clone https://github.com/sstephenson/bats.git
cd bats
./install.sh /usr/local
```

## Simple Conditionals

Following a cheatsheet of conditionals to help prevent running commands multiple times.
Those are valid bash conditions, which are just beeing checked before the actual script
is run.

```bash
[//]: #conditional (! command -v [command] &> /dev/null)
```bash
# only execute block if [command] does not exist
sudo apt -y install [command]
...
```

```bash
[//]: #conditional ([[ "$OSTYPE" == "linux-gnu" ]])
```bash
# run if OSTYPE is "linux-gnu"
cmake -DLINUX_GNU
...
```

```bash
[//]: #conditional ([[ ! -f [file] ]])
```bash
# only execute block if [file] does not exist
touch file
...
```
