package Dist::HomeDir;

# ABSTRACT:  easily find the distribution home directory for code never intended to be installed via a package manager
use warnings;
use strict;
use Path::Tiny;

my $home;

sub dist_home {
    return $home if $home;
    my $cwd = path((caller)[1])->parent;
    $home = _get_dist_home($cwd);
    return $home->absolute;
}

sub _get_dist_home {
    my ($dir) = @_;
    my @ls;
    my $itr = $dir->iterator;
    while (my $f = $itr->() ) {
        push @ls, $f;
    }
    if ( grep { $_->basename =~ /^Makefile.PL|Build.PL|dist.ini|cpanfile|lib|blib$/ 
                    && $_->parent->basename !~ /^t|script|bin$/
            } @ls ) {
        return $dir;
    }
    else {
        return _get_dist_home($dir->parent);
    }
}
1;
__END__
=head2 NAME

Dist::HomeDir

=head2 SUMMARY

    use Dist::Homedir;
    my $dist_home = Dist::Homedir::dist_home(); # A Path::Tiny object of the Dist home

Easily find the dist homedir for an application set up as a cpan(ish)
distribution but intended to be deployed via git checkout or by a tarball
in a self contained directory.  DO NOT use this in code that is B<ever>
likely to be installed via cpan or other package manager.

=head2 DESCRIPTION

This module was inspired by Catalyst::Utils->home() to obtain the root
directory for obtaining application code and self-contained support data in
directories relative to the distribution root.  It does this by returning a
L< Path::Tiny > object which has a very nice interface.  However
Catalyst::Utils->home only works for perl classes.  This works for class
files and perl scripts via examining C< (caller)[1] > and thus should
B<never> be used in code that will be instaled via a cpan client or other
package manager.

Sometimes support libaries will also live in the C<t/lib> directory and the
C<script/lib> directory.  C< dist_home > will ignore C< lib > directories
as part of finding the distribution root.  Future versions of this module
may make the list of what directories to ignore C< lib > sub directories
user-configurable (patches welcome).

=head2 FUNCTIONS

dist_home

Returns a L<Path::Tiny> object of where the current code file executed
thinks the distribution home directory is.

=cut