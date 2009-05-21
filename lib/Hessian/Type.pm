package Hessian::Type;

use warnings;
use strict;

=head1 NAME

Hessian::Type - The great new Hessian::Type!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Hessian::Type;

    my $foo = Hessian::Null->new();
    
    my $bar = Hessian::List->new(
        type => 'java.lang.String',
        len  => 1,
        data => [
                'hello',
                'world',
                ]
    );
    ...

=head1 FUNCTIONS

=head2 new

=cut

sub new {
    my($class,@params) = @_;
    my $self = {};
    %$self = (@params);
    bless $self, $class;
    return $self;
}

package Hessian::Null;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);

package Hessian::True;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);

package Hessian::False;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);

package Hessian::Binary;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);

package Hessian::XML;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);

package Hessian::Double;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);

package Hessian::List;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);

package Hessian::Map;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);

package Hessian::Remote;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);

package Hessian::Fault;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);

#Hessian 2.0
package Hessian::Class;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);

package Hessian::Object;
use vars qw(@ISA);
@ISA = qw(Hessian::Type);
=head1 AUTHOR

du ling, C<< <ling.du at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-hessian-type at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Hessian-Client>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Hessian::Client


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Hessian-Client>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Hessian-Client>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Hessian-Client>

=item * Search CPAN

L<http://search.cpan.org/dist/Hessian-Client>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 du ling, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Hessian::Type
