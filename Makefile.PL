use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Text::Rhyme',
    'VERSION_FROM'	=> 'Rhyme.pm', # finds $VERSION
    'PREREQ_PM'		=> {Text::Soundex => 1.0}, # e.g., Module::Name => 1.1
);
