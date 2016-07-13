package DemoApp::View::HTML;
use Moose;
use namespace::autoclean;

=head1 NAME

DemoApp::View::HTML

=head1 Description

TT view for DemoApp

=cut

extends 'Catalyst::View::TT';

__PACKAGE__->config(
	TEMPLATE_EXTENSION => '.tt2',

	INCLUDE_PATH => [
		DemoApp->path_to( 'root', 'src' ),
	],
	TIMER => 0,
	WRAPPER => 'wrapper.tt2',
	
	render_die => 1,
);

1;
