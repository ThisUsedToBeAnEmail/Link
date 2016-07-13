#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'DemoApp';
use DemoApp::Controller::Book;

my ($res, $c) = ctx_request('/author/1/book/2/view');

my $book = $c->model('DB::Book')->find(1);
my $author = $c->model('DB::Author')->find(1);

subtest 'up the chain - basics' => sub {
    basic_test({
        endpoint => 'list',
        expected => 'http://localhost/author/1/book/list',
    });
    basic_test({
        endpoint => 'create',
        expected => 'http://localhost/author/1/book/create',
    });
    basic_test({
        endpoint => 'view',
        expected => 'http://localhost/author/1/book/2/view',
    });
    basic_test({
        endpoint => 'edit',
        expected => 'http://localhost/author/1/book/2/edit',
    });
};

subtest 'up the chain - drop a capture' => sub {
    basic_test({
        endpoint => '</list',
        expected => 'http://localhost/author/list',
    });
    basic_test({
        endpoint => '</create',
        expected => 'http://localhost/author/create',
    });
    basic_test({
        endpoint => '</view',
        expected => 'http://localhost/author/1/view',
    });
    basic_test({
        endpoint => '</edit',
        expected => 'http://localhost/author/1/edit',
    });
};

subtest 'up the chain - and back down 1 capture' => sub {
    basic_test({
        endpoint => '<../../book/list',
        expected => 'http://localhost/book/list',
    });
    basic_test({
        endpoint => '<../../book/create',
        expected => 'http://localhost/book/create',
    });
    basic_test({
        endpoint => '<../../book/view',
        capture => { book => $book },
        expected => 'http://localhost/book/1/view',
    });
    basic_test({
        endpoint => '<../../book/edit',
        capture => { book => $book },
        expected => 'http://localhost/book/1/edit',
    });
};

subtest 'up the chain - switch' => sub {
    basic_test({
        endpoint => '<../../book/author/list',
        capture  => { book => $book },
        expected => 'http://localhost/book/1/author/list',
    });
    basic_test({
        endpoint => '<../../book/author/create',
        capture  => { book => $book },
        expected => 'http://localhost/book/1/author/create',
    });
    basic_test({
        endpoint => '<../../book/author/view',
        capture => { book => $book, author => $author },
        expected => 'http://localhost/book/1/author/1/view',
    });
    basic_test({
        endpoint => '<../../book/author/edit',
        capture => { book => $book, author => $author },
        expected => 'http://localhost/book/1/author/1/edit',
    });
};

# this is wrong - in the sense why would you ever do it 
# but w/evs you get the nuts concept ;)
# how would I do the below but with different captures
subtest 'up the chain - mega switch' => sub {
    basic_test({
        endpoint => '<../../book/author/book/author/list',
        capture  => { book => $book, author => $author },
        expected => 'http://localhost/book/1/author/1/book/1/author/list',
    });
    basic_test({
        endpoint => '<../../book/author/book/author/create',
        capture  => { book => $book, author => $author },
        expected => 'http://localhost/book/1/author/1/book/1/author/create',
    });
    basic_test({
        endpoint => '<../../book/author/book/author/view',
        capture => { book => $book, author => $author },
        expected => 'http://localhost/book/1/author/1/book/1/author/1/view',
    });
    basic_test({
        endpoint => '<../../book/author/book/author/edit',
        capture => { book => $book, author => $author },
        expected => 'http://localhost/book/1/author/1/book/1/author/1/edit',
    });
};

subtest 'up the chain - mega switch' => sub {
    basic_test({
        endpoint => '<../../book/author/book/author/list',
        capture  => [1, 2, 3],
        expected => 'http://localhost/book/1/author/2/book/3/author/list',
    });
    basic_test({
        endpoint => '<../../book/author/book/author/create',
        capture  => [1, 2, 3],
        expected => 'http://localhost/book/1/author/2/book/3/author/create',
    });
    basic_test({
        endpoint => '<../../book/author/book/author/view',
        capture  => [1, 2, 3, 4],
        expected => 'http://localhost/book/1/author/2/book/3/author/4/view',
    });
    basic_test({
        endpoint => '<../../book/author/book/author/edit',
        capture  => [1, 2, 3, 4],
        expected => 'http://localhost/book/1/author/2/book/3/author/4/edit',
    });
};

sub basic_test {
    my ($args) = shift;

    my $endpoint = $args->{endpoint};
    my $captures = $args->{capture};
    #$self->link('edit', { book_id => 1 })
    my $link = $c->link($endpoint, $captures);
    is( $link, $args->{expected}, "Generate the correct link - $args->{expected}");
}

done_testing();
