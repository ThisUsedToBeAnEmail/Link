package DemoApp::Form::Book::Base;

use HTML::FormHandler::Moose;
extends 'DemoApp::Form';

use namespace::autoclean;

has '+item_class' => ( default => 'Book' );

has 'author_rs' => (
    is => 'ro',
    isa => 'DBIx::Class::ResultSet'
);

has 'shop_rs' => (
    is => 'ro',
    isa => 'DBIx::Class::ResultSet'
);

has_field 'title' => (
    type => 'Text',
    required => 1
);

has_field 'description' => (
    type => 'TextArea',
    required => 1
);

has_field 'cover_image' => (
    type => 'Text',
    label => 'Book Image',
    required => 1
);
# Could make types
has_field 'rating' => (
    type => 'Select',
    required => 1
);

sub options_rating {
    my  $self = shift;
    
    my @options;
    my $max = 5;
    for( my $i = 1; $i <= $max; $i++){
        push @options, { value => $i, label => $i };
    }
    return @options;
}

has_field 'authors' => (
    type => 'Multiple',
    widget => 'CheckboxGroup',
);

has_field 'submit' => (
    type => 'Submit',
    label => 'Save',
);

__PACKAGE__->meta->make_immutable;

1;
