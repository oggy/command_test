# Command Test

Test that your app runs or does not run commands.

## Why?

Ruby has a bucket of ways to run commands:

 * Kernel#system
 * Kernel#`
 * Kernel.open
 * IO.popen
 * Open3.popen3

Mocking becomes impractical because you seldom care *how* a command is
run, just that it *is* run (or not run). Methods that run the command
through the shell are also tricky to mock correctly, as extra shell
syntax can easily throw off the test.

## How

### RSpec

    lambda do
      ...
    end.should run_command('convert', 'bad.gif', 'good.png')

### Test::Unit

    assert_runs_command 'convert', 'bad.gif', 'good.png' do
      ...
    end

    assert_does_not_run_command 'convert', 'bad.gif', 'good.png' do
      ...
    end

### Other frameworks

Not really using them myself, but I'll bet they're easy to add. Patch
me and be famous!

## Tricks

### Regexps

You can match arguments against regexps:

    lambda do
      ...
    end.should run_command('convert', /.gif\z/, /.png\z/)

### Wildcards

An integer, `n`, matches any `n` arguments:

    lambda do
      system 'diff', 'old.txt', 'new.txt')
    end.should run_command('diff', 2)

An range matches any number of arguments in that range:

    lambda do
      system 'diff', '-w', 'one.txt', 'two.txt', 'three.txt'
    end.should run_command('diff', '-w', 2..3)

`:*` matches any number of arguments:

    lamdba do
      system 'hostname'
    end.should run_command('convert', :*, 'target.png')

`:+` matches at least one argument:

    lamdba do
      system 'hostname'
    end.should run_command('gem', 'install', :+)

Any combination of wildcards can be used together.

### Recording

You can record the commands run during a block:

    commands = CommandTest.record do
      system 'convert', 'bad.gif', 'good.png'
      system 'identify', 'good.png'
    end
    commands # [['convert', 'bad.gif', 'good.png'], ['identify', 'good.png']]

And then match them yourself:

    CommandTest.match?(commands.first, ['convert', :*])

You can use this to check that commands were run in a certain order, a
certain number of times, in a pretty pattern, ... the possibilities
are endless!

## Contributing

 * Bug reports: http://github.com/oggy/command_test/issues
 * Source: http://github.com/oggy/command_test
 * Patches: Fork on Github, send pull request.
   * Ensure patch includes tests.
   * Leave the version alone, or bump it in a separate commit.

## Copyright

Copyright (c) 2010 George Ogata. See LICENSE for details.
