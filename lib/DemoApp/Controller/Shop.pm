package DemoApp::Controller::Shop;
use Moose;
use namespace::autoclean;

BEGIN { extends 'DemoApp::Controller' }

__PACKAGE__->config(namespace => 'shop');

=encoding utf-8

=head1 NAME

DemoApp::Controller::Shop 

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 base

=cut

sub base :Chained('/') :PathPart('shop')  :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash(shop_rs => $c->model('DB::Shop'));
}

sub list :Chained('base') :PathPart('list') :Args(0) {
    my ($self, $c) = @_;

}

=head1 AUTHOR

LNATION

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
