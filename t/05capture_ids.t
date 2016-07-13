#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'DemoApp';
use DemoApp::Controller::Book;

my ($res, $c) = ctx_request('/author/1/view');
subtest 'captures from base controller - capture_id' => sub {
    basic_test({
        endpoint => '/book/list',
        expected => 'http://localhost/book/list',
    });
    basic_test({
        endpoint => '/book/create',
        expected => 'http://localhost/book/create',
    });
    basic_test({
        endpoint => '/book/view',
        captures => { book_id => 1 },
        expected => 'http://localhost/book/1/view',
    });
    basic_test({
        endpoint => '/book/edit',
        captures => { book_id => 1 },
        expected => 'http://localhost/book/1/edit',
    });
};

# 99% of the time you I actually want to do this 
# books is not a great example :) 
# I shouldn't need to pass in the author capture
subtest 'basics from stub controller - capture_id' => sub {
    basic_test({
        endpoint => 'book/list',
        expected => 'http://localhost/author/1/book/list',
    });
    basic_test({
        endpoint => 'book/create',
        expected => 'http://localhost/author/1/book/create',
    });
    basic_test({
        endpoint => 'book/view',
        captures => { book_id => 1 },
        expected => 'http://localhost/author/1/book/1/view',
    });
    basic_test({
        endpoint => 'book/edit',
        captures => { book_id => 1 },
        expected => 'http://localhost/author/1/book/1/edit',
    });
};

sub basic_test {
    my ($args) = shift;

    my $endpoint = $args->{endpoint};
    my $captures = $args->{captures};
    #$self->link('edit', { book_id => 1 })
    my $link = $c->link($endpoint, $captures);
    is( $link, $args->{expected}, "Generate the correct link - $args->{expected}");
}

done_testing();
