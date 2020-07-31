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
