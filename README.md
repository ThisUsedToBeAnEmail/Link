# NAME

Catalyst::Link

# SYNOPSIS

Include the Plugin in your application class:

    package MyApp;
    use Catalyst qw/
        Link
    /;

Then add the following to any controllers you want to use link

    with 'Catalyst::Controller::Role::Link';

Alternatively if you want to use it throughout your controllers 
Create a base...

    package MyApp::Controller;
    use Moose;
    
    BEGIN { extends 'Catalyst::Contoller' };
    with 'Catalyst::Controller::Role::Link';

obviously not forgetting to switch out the BEGIN in each of your controllers.

    package DemoApp::Controller::Book';
    BEGIN { extends 'MyApp::Controller' };

Finally you now have an option, link needs to associate capturedArgs with a key
Its default behaviour is to use the actions PathPart, however not every capture 
has a PathPart so for these occasion you can set a Name attribute.

    sub chain :Chained('base') :PathPart('') :CapturedArgs(1) :Name('author'){}

basic usage $c->link($action, @||%captured\_args, %query\_params),

    # if you are in a controller say book/list we need a capture to get to edit 
    # if you have an object and you're lazy like me
    $c->link('edit', { book => $book }); 
    # if you just have an id
    $c->link('edit', { book_id => $id }); 
    # but then again why not just do this
    $c->link('edit', [$id]);
    # sometimes you may want to be a little more specific on the desired controller
    $c->controller('Book')->link($c, 'edit', [$book->id]),

you can also use this in your templates

    [% c.link('edit', [book.id]) %]

# DESCRIPTION

Link allows you to build dynamic links... which leads to extendable controllers.

Currently I do not think there is a way of building a uri for a relative path.

For example if I wanted the same functionality in several places accross my web app,
I could build my controllers at the root and then simply extend them as stub controllers in the relevant places, Alternatively you can do similar with controller roles.

However what I discovered was uri\_for\_action can get very messy very quickly (for a newb). It's currently not smart enough to understand where the user is in the chain and where they should be linked to next. 

link uses the dispatcher to lookup a pre-processed action\_path. We then loop through each action in that dispatcher chain to check whether any CapturedArgs are associated. Once we have that its simple to build the correct uri\_for\_action call without all the mess. 

# METHODS

## link

There are two ways of calling link 

    $c->link($action_name, $args, $query_values)
    $c->controller('Book')->link($c, $action_name, $args, $query_values);

### action\_name

- root

        # http://localhost/
        $c->link('/');

- link within the controller

        $c->link('view')

- from the root

        # http://localhost/book/list
        $c->link('/book/list');

- relatively down the chain

        # start url http://localhost/author/1/view 
        # http://localhost/author/1/book/list
        $c->link('book/list');

- relatively up the chain droping one capture

        # start url http://localhost/author/1/book/1/view 
        # http://localhost/author/1/view
        $c->link('</view');

    '<' tells link that we are going up the chain 

- relatively up the chain and then down again

        # start url http://localhost/author/1/book/1/view 
        # http://localhost/book/list
        $c->link('<../../book/list');

    '..' tells link that we need to drop a capture, you can drop as many as you like '<../../..' 

### args

- object

        $c->link('edit', { capture => $object });

- id

        $c->link('edit', { capture_id => $id });

- array

        $c->link('edit', [ $id ]);

### query\_params

Exactly the same as you would for uri\_for\_action

    # http://localhost/author/1/edit?this=thing
    $c->link('edit', [$id], { this => 'thing' });


NOTE the demoapp is just to demonstrate stub controllers at different levels
currently the captures will not be stored for each level - to achieve this would take some thought
would probably have to think about joining a unique id by counting the occurances of the same 
'Named' capture - edge cases
