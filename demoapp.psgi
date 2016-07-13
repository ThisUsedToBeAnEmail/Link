use strict;
use warnings;

use DemoApp;

my $app = DemoApp->apply_default_middlewares(DemoApp->psgi_app);
$app;

