package LearningMojo::Login;
use Mojo::Base 'Mojolicious::Controller';

sub form {}

sub create {
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
}

sub destroy {
  my $self = shift;
  $self->session(expires => 1);
  $self->flash(success => 'You are now logged out!');
  $self->redirect_to('login');
}

sub logged_in {
  my $self = shift;

  # Redirect to main page with a 302 response if user is not logged in
  return 1 if $self->session('user');
  $self->flash(error => 'You must log in to access that content');
  $self->redirect_to('login');
  return undef;
}

1;
