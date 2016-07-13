package DemoApp::Controller;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' };
with 'Catalyst::Controller::Role::Link';
