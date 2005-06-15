use strict;

use Test::More qw(no_plan);
#use Test::More tests => 2;

use RT;
RT::LoadConfig;
RT::Init;

# make sure the modules are installed
use_ok('RT::Extension::AddAdminCcsOnQueueChange');
use_ok('RT::Action::AddQueueAdminCcs');

my ($id, $message);

# create queues
my $watched_queue = RT::Queue->new($RT::SystemUser);
($id, $message) = $watched_queue->Create( Name=>"Watched-$$" );
ok($id, "Queue created? $message");

my $unwatched_queue = RT::Queue->new($RT::SystemUser);
($id, $message) = $unwatched_queue->Create( Name=>"Unwatched-$$" );
ok($id, "Queue created? $message");

# handles a single watcher?
($id, $message) = $watched_queue->AddWatcher( Type => 'AdminCc',
                                              Email => 'watcher1\@example.com'
                                            );
ok($id, "Added watcher1? $message");

# doesn't add watchers on creation of ticket
my $ticket_1 = RT::Ticket->new($RT::SystemUser);
($id, $message) = $ticket_1->Create( Queue => "Watched-$$",
                                     Requestor => 'requestor\@example.com',
                                     Subject => 'AutoAddAdminCcs test 1',
                                     AdminCc => ''
                                   );
ok($id, "Created ticket 1? $message");
ok($ticket_1->AdminCcAddresses !~ /watcher1\@example.com/, "Doesn't add AdminCcs on ticket creation");

# does add watchers when ticket moves out of the queue
($id, $message) = $ticket_1->SetQueue("Unwatched-$$");
ok($id, "Moved ticket? $message");
ok($ticket_1->AdminCcAddresses =~ /watcher1\@example.com/, "Adds AdminCcs on move out of watched queue: ".$ticket_1->AdminCcAddresses);

# doesn't add watchers when the ticket gets moved back
($id, $message) = $watched_queue->AddWatcher( Type => 'AdminCc',
                                              Email => 'watcher2\@example.com'
                                            );
ok($id, "Added watcher2? $message");
($id, $message) = $ticket_1->SetQueue("Watched-$$");
ok($id, "Moved ticket? $message");
ok($ticket_1->AdminCcAddresses !~ /watcher2\@example.com/, "Doesn't add AdminCcs on move into watched queue");

# deals properly with multiple watchers
($id, $message) = $watched_queue->AddWatcher( Type => 'AdminCc',
                                              Email => 'watcher3\@example.com'
                                            );
ok($id, "Added watcher3? $message");
($id, $message) = $ticket_1->SetQueue("Unwatched-$$");
ok($id, "Moved ticket? $message");
ok($ticket_1->AdminCcAddresses =~ /watcher2\@example.com/ && $ticket_1->AdminCcAddresses =~ /watcher3\@example.com/, "Adds multiple AdminCcs on move out of watched queue");

1;
