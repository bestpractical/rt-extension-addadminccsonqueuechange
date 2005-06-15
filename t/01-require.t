use strict;

use Test::More qw(no_plan);
#use Test::More tests => 2;

# make sure the modules are installed
use_ok('RT::Extension::AddAdminCcsOnQueueChange');
use_ok('RT::Action::AddQueueAdminCcs');

my ($id, $message);

# create queues
my $watched_queue = RT::Queue->new($RT::SystemUser);
($id, $message) = $watched_queue->Create( Name=>'Watched' );
ok($id, "Queue created? $message");

my $unwatched_queue = RT::Queue->new($RT::SystemUser);
($id, $message) = $unwatched_queue->Create( Name=>'Unwatched' );
ok($id, "Queue created? $message");

# handles a single watcher?
($id, $message) = $watched->queue->AddWatchers( Type => 'AdminCc',
                                                Email => 'watcher1\@example.com'
                                              );
ok($id, "Added watcher1? $message");

# doesn't add watchers on creation of ticket
my $ticket1 = RT::Ticket->new($RT::SystemUser);
($id, $message) = $ticket1->Create( Queue => 'general',
                                    Requestor => 'requestor\@example.com',
                                    Subject => 'AutoAddAdminCcs test 1',
                                    AdminCc => ''
                                  );
ok($id, "Created ticket 1? $message");


1;
