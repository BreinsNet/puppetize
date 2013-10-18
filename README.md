

# puppetize

## Preface

If you are a sysadmin or a developer that as a daily job has to create
and mantain multiple puppet modules, this is the tool for you.

Package maintainers work hard and take a lot of shit. You can't please
everyone. So, if you're a maintainer: Thanks for maintaining packages!

## State

This is alpha beta unstable dev ultra unstable all together software 
at the moment, I would say is more like a proof of concept to see 
how useful this module would be.

USE IT AT YOUR OWN RISK... which is pretty high :-)

## What is puppetize?

Puppetize is an automated puppet module generation tool.

It helps you build puppet modules quickly and easily
formats).

FUNDAMENTAL PRINCIPLE: IF PUPPETIZE IS NOT HELPING YOU MAKE PUPPET MODULES 
EASILY, THEN THERE IS A BUG IN PUPPETIZE.

puppetize will collect every detail about your system. You then can 
start to work on installing your RPMs, tune your configuration
files and start or stop the necessary services... as you would do 
in the old good days.

puppetize will then catch all those differences and build a standard
puppet module. It'll use the standard puppet structure from puppet
forge and it will finally write the manifests using the best practices
out there.

## Get with the download

You can install puppetize with gem:

    gem install fpm

Gather the initial state might look something like this:

    puppetize init

Build the module will be something like:

    puppetize build

Finally you can reset the state and start over doing:

    puppetize reset

## Need Help or Want to Contribute?

All contributions are welcome: ideas, patches, documentation, bug reports,
complaints, and even something you drew up on a napkin.

It is more important to me that you are able to contribute and get help if you
need it..

## More Documentation

None yet


