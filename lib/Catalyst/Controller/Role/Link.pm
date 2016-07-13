package Catalyst::Controller::Role::Link;
use Moose::Role;
use Carp;

sub link {
    my ( $self, $c, $action_name, $args, $query_values ) = @_;

    # if not defined default
    $args         ||= {};
    $query_values ||= {};
   
    # check the action_name exists in the controller
    my $target_action = $self->action_for($action_name)
        || croak qq{'$action_name' action does not exist in your controller};

    my $captures;
    if ( ref $args eq q{ARRAY} ) {
        $captures = [ @{$args} ];
    }
    else {
        $captures = $self->_build_captured_args( $c, $target_action, $args );
    }

    return $c->uri_for_action( $target_action, $captures, $query_values );
}

sub _build_captured_args {
    my ( $self, $c, $target_action, $args ) = @_;

    # look for all the capture names that are in our current chain
    my $capture_names = $self->_build_captured_names( $c, $target_action, $args );

    # Now loop through those names associating the values
    my @captures;
    foreach my $capture_name ( @{$capture_names} ) {
        my $capture;
        
        if ( exists $args->{ $capture_name . q{_id} } ) {
            $capture = $args->{ $capture_name . q{_id} };
        }
        elsif ( my $object = $args->{$capture_name} || $c->stash->{$capture_name} ) {
            # check we actually have an object
            croak qq{$capture_name object '$object' is not an object}
                unless blessed $object;
           
            # check the object has an id - which it is wrong :) 
            # we may want the capture to actually be ->name etc 
            croak qq{$capture_name object '$object' has no 'id' method}
                unless $object->can(q{id});
            
            $capture = $object->id;
        }

        croak qq{No value for the '$capture_name' capture} unless $capture;

        push @captures, $capture;
    }

    return \@captures;
}

sub _build_captured_names {
    my ( $self, $c, $target_action, $args ) = @_;

    my @capture_names;
    my $chain = $c->dispatcher->expand_action($target_action);

    # loop through each action in the current chain
    foreach my $action ( @{ $chain->chain } ) {

        # check whether that action has any CapturedArgs associated
        my ($arg_count) = @{ $action->attributes->{CaptureArgs} || [] };
        next unless $arg_count;

        # Either take an explicit list of names from the :ID attribute
        my @names;
        if ( my $names_ref = $action->attributes->{Name} ) {
            push @names, @{$names_ref};
        }
        # or assume the PathPart is what we want
        else {
            push @names, $action->attributes->{PathPart}[0];
        }

        # Check we have the correct @names count relevant to what we expect
        croak qq{The arg count does not match the number of capture names '@names', '$arg_count'}
            unless scalar @names == $arg_count;

        push @capture_names, @names;
    }

    return \@capture_names;
}

1;
