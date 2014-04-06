package LearningMojo::StaticPages;
use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $self = shift;
  my $user = $self->param('user') || 'Dave';
  $self->stash(user => $user);
}

sub agent {
  my $self = shift;
  my $host = $self->req->url->to_abs->host;
  my $ua = $self->req->headers->user_agent;
  $self->stash(host => $host, ua => $ua);
}

sub meowf {}

sub page {
  my $self = shift;
  $self->stash(seven => 47);
}

1;
