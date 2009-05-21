use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Hessian::Client',
    license             => 'perl',
    dist_author         => 'du ling <ling.du@gmail.com>',
    dist_version_from   => 'lib/Hessian/Client.pm',
    build_requires => {
        'Test::More'      => 0,
        'URI'             => 0,
        'Math::BigInt'    => 0,
        'Unicode::String' => 0,
    },
    add_to_cleanup      => [ 'Hessian-Client-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
