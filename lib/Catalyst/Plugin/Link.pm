package Catalyst::Plugin::Link;
use Moose;
use Carp;

sub link {
    my ( $c, $action_name, $args, $query_values ) = @_;
   
    my $controller = $c->controller;
    # revert to uri_for when a single / is passed in as an action, this will
    # direct to the homepage/root directory
    if ( $action_name eq q{/} ) {
        return $c->uri_for( $action_name, @{ $args || [] },
            $query_values || {} );
    }
    # the action is a path ie '/workspace/blah/foo' then find the
    # controller and action from the dispatcher
    elsif ( $action_name =~ m{^/} ) {
        ( $controller, $action_name ) = $c->_get_action_by_path($action_name);
    }
    # the action is a path leading with '<' then it means we are going up the chain
    elsif ( $action_name =~ s{^<}{} ) {
        ( $controller, $action_name ) = $c->_within_context($action_name);
    }

    # pass to Catalyst::Controller::Role::Link
    $controller->link( $c, $action_name, $args, $query_values );
}

sub _within_context {
    my ( $c, $action_name ) = @_;

    # split action so we can see how many steps to take back
    my @link = split( q{/}, $action_name );

    # take the last argument as the action name, second last as the end of the namespace
    $action_name = pop @link;

    # @link = [ '..', '..', 'list' ]
    # loop through the array to see if we have instructions to take capture arg steps
    my $link_count = 0;
    for my $link_step (@link) {
        if ( $link_step eq q{..} ) {
            $link_count++;
        }
        else {
            last;
        }
    }

    my $namespace = join( q{/}, @link[ $link_count .. scalar @link - 1 ] );

    my $controller;
    if ($link_count) {
        # rebuild the action, and pass it to get_action_by_path which will return the final
        # controller and action_name.
        ( $controller, $action_name ) = $c->_get_action_by_path(
             $namespace . q{/} . $action_name 
        );
    }
    else {
        # we are linking back through the chain however the namespace exists within the chain
        my $current_action = $c->action;
        $controller = $c->_get_context_controller( 
            $current_action, $namespace 
        );
    }

    return ( $controller, $action_name );
}

sub _get_context_controller {
    my ( $c, $current_action, $namespace ) = @_;

    my $chain_action;
    for ( my $i = scalar( @{ $current_action->chain } ) - 1 ; $i >= 0 ; $i-- ) {
        $chain_action = $current_action->chain->[$i];
        last if $chain_action->namespace =~ /\/$namespace$/;
    }

    return $c->component( $chain_action->class );
}

sub _get_action_by_path {
    my ( $c, $action_name ) = @_;

    my $action = $c->dispatcher->get_action_by_path($action_name)
        || croak qq{'$action_name' action does not exist in your controller};
    
    my $controller = $c->component( $action->class );

    return ( $controller, $action->name );
}

1;
