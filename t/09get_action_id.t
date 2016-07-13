#!/usr/bin/env perl        
use strict;        
use warnings;        
use Test::More;        
        
use Catalyst::Test 'DemoApp';        
use DemoApp::Controller::Book;        
        
# John Napiorkowski Idea's        
subtest 'up the chain - basics' => sub {        
    basic_test({        
        controller => 'Root',        
        id => 'book_list',        
        action => '/book/list'        
    });        
    basic_test({        
        controller => 'Root',        
        id => 'add_book',        
        action => '/book/create'        
    });        
    basic_test({        
        # give any id it doesn't have to be sensible        
        controller => 'Root',        
        id => 'foo',        
        action => '/book/2/view'        
    });        
    basic_test({        
        controller => 'Root',        
        id => 'view_books',        
        action => 'book/2/edit'        
    });        
};        
# What I want to be able to do        
subtest 'up the chain - drop a capture' => sub {        
    basic_test({        
        controller => 'Author',        
        id => 'book_list',        
        action => '/author/book/list',        
    });        
    basic_test({        
        controller => 'Author',        
        id => 'add_book',        
        action => '/author/book/create',        
    });        
    basic_test({        
        # give any id it doesn't have to be sensible        
        controller => 'Author',        
        id => 'foo',        
        action => '/author/book/view',        
    });        
    basic_test({        
        id => 'view_books',        
        action => '/author/book/edit',        
    });        
};        
        
sub basic_test {        
    my ($args) = shift;        
        
    # This will be called inside link        
    my $action = DemoApp->get_action_id($controller, $args->{id});        
    is( $action, $args->{action}, "Generate the correct link - $args->{action}");        
}        
        
done_testing();
