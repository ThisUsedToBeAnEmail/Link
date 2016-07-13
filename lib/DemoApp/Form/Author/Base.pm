package DemoApp::Form::Author::Base;

use HTML::FormHandler::Moose;
extends 'DemoApp::Form';

use namespace::autoclean;

has '+item_class' => ( default => 'Author' );

has_field 'first_name' => (
    type => 'Text',
    label => 'First Name',
    required => 1
);

has_field 'last_name' => (
    type => 'Text',
    label => 'Last Name',
    required => 1
);

has_field 'submit' => (
    type => 'Submit',
    label => 'Save'
);

__PACKAGE__->meta->make_immutable;

1;
