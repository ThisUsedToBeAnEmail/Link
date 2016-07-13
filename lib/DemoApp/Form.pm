package DemoApp::Form;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'DemoApp::Form::Theme::Boot';

1;
