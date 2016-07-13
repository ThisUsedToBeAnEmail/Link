package DemoApp::Controller::Author::Book;
use Moose;
use namespace::autoclean;

BEGIN { extends 'DemoApp::Controller::Book' }

=encoding utf-8

=head1 NAME

DemoApp::Controller::Book 

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub base :Chained('/author/chain') :PathPart('book')  :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    my $book_ids = $c->model('DB::BookAuthor')->search_rs({ author_id => $c->stash->{author}->id })->get_column('book_id');
    $c->stash(book_rs => $c->model('DB::Book')->search_rs({ id => { 'IN' => $book_ids->as_query }}));
} 

__PACKAGE__->meta->make_immutable;

1;
