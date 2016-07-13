package DemoApp::Controller::Book;
use Moose;
use namespace::autoclean;

use DemoApp::Form::Book::Create;
use DemoApp::Form::Book::Edit;

BEGIN { extends 'DemoApp::Controller' }

=encoding utf-8

=head1 NAME

DemoApp::Controller::Book 

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 base

=cut

sub base :Chained('/') :PathPart('book')  :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash(book_rs => $c->model('DB::Book'));
}

sub list :Chained('base') :PathPart('list') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'book/list.tt2';
}

sub create :Chained('base') :PathPart('create') :Args(0) {
    my ($self, $c) = @_;
    
    my $class = 'DemoApp::Form::Book::Create';
    my $book = $c->stash->{book_rs}->new_result({});
    
    $c->stash->{template} = 'book/create.tt2';
    return $self->form($c, $class, $book);
}

sub chain :Chained('base') :PathPart('') :CaptureArgs(1) :Name('book'){
    my ($self, $c, $id) = @_;

    $c->stash(book => $c->stash->{book_rs}->find($id));

    die "book $id not found" unless $c->stash->{book};
} 

sub view :Chained('chain') :PathPart('view') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'book/view.tt2';
}

sub edit :Chained('chain') :PathPart('edit') :Args(0) {
    my ($self, $c) = @_;

    my $class = 'DemoApp::Form::Book::Edit';
    my $book = $c->stash->{book};

    $c->stash->{template} = 'book/edit.tt2';
    return $self->form($c, $class, $book);
}

sub form {
    my ($self, $c, $class, $book) = @_;

    my $author_rs = $c->model('DB::Author');
    my $form = $class->new(
        id => $book->id,
        author_rs => $author_rs,
    );

    $c->stash( template => 'book/form.tt2', form => $form );

    $form->process( item => $book, params => $c->req->params );

    if ($form->validated) {
        $c->response->redirect($c->link('view', { book => $book }));
    }
}

=head1 AUTHOR

LNATION

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
