package DemoApp::Form::Theme::Boot;
use Moose::Role;

sub build_update_subfields {{
	all => {
		wrapper_tag => 'div',
		wrapper_class => 'form-group',
		label_class => 'control-label',
		element_class => 'form-control',
	}
}}

1;
