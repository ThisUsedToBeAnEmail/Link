#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'DemoApp';
use DemoApp::Controller::Book;

my ($res, $c) = ctx_request('/');

subtest 'basics from base controller' => sub {
    basic_test({
        controller => 'Book',
        endpoint => 'list',
        expected => 'http://localhost/book/list',
    });
    basic_test({
        controller => 'Book',
        endpoint => 'create',
        expected => 'http://localhost/book/create',
    });
    basic_test({
        controller => 'Book',
        endpoint => 'view',
        captures => { book_id => 1 },
        expected => 'http://localhost/book/1/view',
    });
    basic_test({
        controller => 'Book',
        endpoint => 'edit',
        captures => { book_id => 1 },
        expected => 'http://localhost/book/1/edit',
    });
};

subtest 'basics from stub controller' => sub {
    basic_test({
        controller => 'Author::Book',
        endpoint => 'list',
        captures => { author_id => 1 },
        expected => 'http://localhost/author/1/book/list',
    });
    basic_test({
        controller => 'Author::Book',
        endpoint => 'create',
        captures => { author_id => 1 },
        expected => 'http://localhost/author/1/book/create',
    });
    basic_test({
        controller => 'Author::Book',
        endpoint => 'view',
        captures => { author_id => 1, book_id => 1 },
        expected => 'http://localhost/author/1/book/1/view',
    });
    basic_test({
        controller => 'Author::Book',
        endpoint => 'edit',
        captures => { author_id => 1, book_id => 1 },
        expected => 'http://localhost/author/1/book/1/edit',
    });
};

sub basic_test {
    my ($args) = shift;

    my $controller = $args->{controller};
    my $endpoint = $args->{endpoint};
    my $captures = $args->{captures};
    #$self->controller('Book')->link('edit', { book_id => 1 })
    my $link = $c->controller($args->{controller})->link($c, $endpoint, $captures);
    is( $link, $args->{expected}, "Generate the correct link - $args->{expected}");
}

done_testing();
