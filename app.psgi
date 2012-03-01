use strict;
use warnings;

use Plack::Builder;
use Plack::App::WrapCGI;
use Plack::App::URLMap;

builder {
    enable 'Static',
	path => qr{^/(images|javascript|pod|styles)/},
	root => './htdocs/';
    enable 'Static',
	path => sub { s!^(/(index.html)?)?$!index.html! },
	root => './htdocs/';
    enable 'Static',
	path => sub { s!^/tmp/!/! },
	root => ($ENV{TMP} || $ENV{TEMP} || '/var/tmp');

    my $map = Plack::App::URLMap->new;
    my $app = Plack::App::WrapCGI->new(script => "perl/critic.pl")->to_app;
    $map->mount("/perl/critic.pl" => sub { $app->(@_) });
    $map->to_app;
};
