package Hessian::Client;

use warnings;
use strict;

use LWP::UserAgent;
use HTTP::Headers;
use List::Util qw/first/;

use Hessian::Translator;
use Hessian::Translator::V1;
use Hessian::Translator::V2;
use Hessian::Type;

=head1 NAME

Hessian::Client - Hessian 1.0 client in perl

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Hessian::Client;

    my $foo = Hessian::Client->new(
        URL => 'http://some.hessian.service/...',
        version => 1,
        auth    => ['user','pass'], # if needed
    );
    my $arg1 = Hessian::True->new();
    my $arg2 = 500;
    my $arg3 = Unicode::String->new('hello world!');
    my $bar = $foo->call('method',$arg1,$arg2,$arg3);
    die $foo->{_error} unless defined $bar;
    ...

=head1 FUNCTIONS

=head2 new

=cut

sub new {
    my($class,@params) = @_;
    my $self = {@params};
    bless $self, $class;

    if($self->{URL}){
        $self->{URI} = URI->new($self->{URL});
        unless($self->{URI}->scheme() eq 'http'){
            return $self->raise_error('URI scheme not http: ', $self->{URI});
        }
    }else{
        return $self->raise_error('URL required in constructor');
    }
    return $self;
}


=head2 call

=cut

sub call {
    my ($self, $method, @params) = @_;

    # create UserAgent
    my $ua = LWP::UserAgent->new;
    $ua->agent("Perl Hessian1.0 Client/$VERSION");

    my $header = HTTP::Headers->new();

    if('ARRAY' eq ref $self->{auth}){
        $header->authorization;
        $header->authorization_basic($self->{auth}->[0],$self->{auth}->[1]);
    }

    my $req= HTTP::Request->new(POST => $self->{URI}, $header);

    if($self->{version} && $self->{version} == 2){
        $self->{translator} = Hessian::Translator::V2->new(debug=>$self->{debug},mangle=>$self->{mangle});
    }else{
        $self->{translator} = Hessian::Translator::V1->new(debug=>$self->{debug},mangle=>$self->{mangle});
    }

    my $content;
    my $tr= $self->{translator};
    eval{
        $content = $tr->writeCall($method, @params);
        1;
    }or return $self->raise_error($@);

    $req->content($content);
    $tr->debug($tr->bin_debug($content)) if $self->{debug};
    my $resp= $ua->request($req);

    $tr->debug("Hessian http response: ",$resp->status_line);

    if($resp->is_success){

        $tr->debug($tr->bin_debug($resp->content)) if $self->{debug};

        eval{
            $self->{reply} = $tr->parseResponse($resp->content);
            1;
        }or return $self->raise_error($@);
        my $f = first {'Hessian::Fault' eq ref $_} @{$self->{reply}};
        return $self->raise_error($tr->dump_fault($f)) if $f;
        my $r = first {ref($_) !~ /^Hessian::(Header|Class)/} @{$self->{reply}};
        return $r;
    }else{

        $tr->debug($resp->content) if $self->{debug};
        return $self->raise_error('Hessian http response unsuccessful: ', $resp->status_line, $resp->error_as_HTML);
    }
}

=head2 raise_error

=cut
sub raise_error { # return undef
    my $self = shift;
    $self->{_error} = join "\n", @_;
    return undef;
}


=head1 Hessian 1.0 Data types mapping

=over 2

=item null

Hessian::Null->new();

=item true

Hessian::True->new();

=item false

Hessian::False->new();

=item date

DateTime (cpan)

=item int

normal perl integer

=item long

Math::BigInt

=item double

Hessian::Double->new(data=>20.09);

=item binary

Hessian::Binary->new(data=>'abcd');

=item string

Unicode::String->new('abcd');

=item xml

Hessian::XML->new(data=> Unicode::String->new('abce'));

=item remote

Hessian::Remote->new(type=> 'bean.x', url => 'http://bean.home');

=item list

  Hessian::List->new(
    type => 'int[',  # optional
    len  => 3,       # optional
    data => [0,1,2],
  );

=item map

  my $joe = Hessian::Map->new(
    type => 'com.caucho.hessian.test.Person',
    data => [
        Unicode::String->new('name') => Unicode::String->new('joe')
    ]
  );

  Hessian::Map->new(
    type => 'com.caucho.hessian.test.Horse',
    data => [
        age => 4,
        sex => Unicode::String->new('m'), 
        owner => $joe
    ],
  );

=back


=head1 AUTHOR

du ling, C<< <ling.du at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-hessian-client at rt.cpan.org>, or through
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

1; # End of Hessian::Client
