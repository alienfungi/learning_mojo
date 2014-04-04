#!/usr/bin/env perl
use Mojolicious::Lite;

use lib qw(lib lib/models);
use MyUsers;

helper users => sub { state $users = MyUsers->new };

get '/login' => sub {
  my $self = shift;
  #delete($self->session->{'error'});
};

post '/login' => sub {
  my $self = shift;

  # Query parameters
  my $user = $self->param('user') || '';
  my $pass = $self->param('pass') || '';

  # Check password
  if($self->users->check($user, $pass)) {
    # Store username in session
    $self->session(user => $user);
    $self->flash(success => "You are now logged in!");
    $self->redirect_to('/');
  } else {
    # Failed
    $self->flash(error => 'Wrong username or password.');
    $self->redirect_to('login');
  }
};

group {
  under sub {
    my $self = shift;

    # Redirect to main page with a 302 response if user is not logged in
    return 1 if $self->session('user');
    $self->flash(error => 'You must log in to access that content');
    $self->redirect_to('login');
    return undef;
  };

  get '/' => sub {
    my $self = shift;
    my $user = $self->param('user') || 'Dave';
    $self->stash(user => $user);
  } => 'index';

  get '/agent' => sub {
    my $self = shift;
    my $host = $self->req->url->to_abs->host;
    my $ua = $self->req->headers->user_agent;
    $self->stash(host => $host, ua => $ua);
  };

  any '/logout' => sub {
    my $self = shift;
    delete($self->session->{'user'});
    $self->flash(success => 'You are now logged out!');
    $self->redirect_to('login');
  };

  get '/meowf';

  get '/page' => sub {
    my $self = shift;
    $self->stash(seven => 47);
  };
};

app->start;
