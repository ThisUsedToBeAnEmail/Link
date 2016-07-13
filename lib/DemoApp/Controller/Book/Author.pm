package DemoApp::Controller::Book::Author;
use Moose;
use namespace::autoclean;

BEGIN { extends 'DemoApp::Controller::Author' }

=encoding utf-8

=head1 NAME

DemoApp::Controller::Author 

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 base

=cut

sub base :Chained('/book/chain') :PathPart('author')  :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    my $author_ids = $c->model('DB::BookAuthor')->search_rs({ book_id => $c->stash->{book}->id })->get_column('author_id');
    $c->stash(author_rs => $c->model('DB::Author')->search_rs({ id => { 'IN' => $author_ids->as_query }}));
}

=head1 AUTHOR

LNATION

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
