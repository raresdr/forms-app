package FormsApp::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

FormsApp::Controller::Root - Root Controller for FormsApp

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 begin

Set page title for the current controller (/)

=cut

sub begin :Private {
    my ( $self, $c ) = @_;
    
    $c->stash( page_title => 'Home' );
}

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    $c->stash(template => 'home.html');
}

=head2 error

Custom error page

=cut

sub error :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    $c->stash(template => 'error.html');
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Rares Catalin Dragomir

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
