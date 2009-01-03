use inc::Module::Install;
name 'Parse-USDASR';
all_from 'lib/Parse/USDASR.pm';

requires 'Rubyish';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';

auto_include;
WriteAll;
