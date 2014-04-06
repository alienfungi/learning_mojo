package LearningMojo;
use Mojo::Base 'Mojolicious';

use MyUsers;

sub startup {
  my $self = shift;

  $self->secrets(['Mojolicious rocks']);
  $self->helper(users => sub { state $users = MyUsers->new });

  my $r = $self->routes;
  $r->get('/login')->to('login#new');
  $r->post('/login')->to('login#create');
  $r->get('/logout')->to('login#destroy');

  my $logged_in = $r->under->to('login#logged_in');
  $logged_in->get('/')->to('static_pages#index');
  $logged_in->get('/agent')->to('static_pages#agent');
  $logged_in->get('/meowf')->to('static_pages#meowf');
  $logged_in->get('/page')->to('static_pages#page');
}

1;
