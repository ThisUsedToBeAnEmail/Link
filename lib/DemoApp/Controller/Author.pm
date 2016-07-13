package DemoApp::Controller::Author;
use Moose;
use namespace::autoclean;

use DemoApp::Form::Author::Create;
use DemoApp::Form::Author::Edit;

BEGIN { extends 'DemoApp::Controller'; }

=encoding utf-8

=head1 NAME

DemoApp::Controller::Author 

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 base

=cut

sub base :Chained('/') :PathPart('author') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash(author_rs => $c->model('DB::Author'));
}

sub list :Chained('base') :PathPart('list') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'author/list.tt2';
}

sub create :Chained('base') :PathPart('create') :Args(0) {
    my ($self, $c) = @_;
    
    my $class = 'DemoApp::Form::Author::Create';
    my $author = $c->stash->{author_rs}->new_result({});
    
    $c->stash->{template} = 'author/create.tt2';
    return $self->form($c, $class, $author);
}

sub chain :Chained('base') :PathPart('') :CaptureArgs(1) :Name('author') {
    my ($self, $c, $id) = @_;

    $c->stash(author => $c->stash->{author_rs}->find($id));

    die "author $id not found" unless $c->stash->{author};
} 

sub view :Chained('chain') :PathPart('view') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'author/view.tt2';
}

sub edit :Chained('chain') :PathPart('edit') :Args(0) {
    my ($self, $c) = @_;

    my $class = 'DemoApp::Form::Author::Edit';
    my $author = $c->stash->{author};
    $c->stash->{template} = 'author/edit.tt2';

    return $self->form($c, $class, $author);
}

sub form {
    my ($self, $c, $class, $author) = @_;
    
    my $form = $class->new(
        id => $author->id,
    );

    $c->stash( template => 'author/form.tt2', form => $form );

    $form->process( item => $author, params => $c->req->params );

    if ($form->validated) {
        $c->response->redirect($c->link('view', { author_id => $author->id }));
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
