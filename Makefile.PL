use inc::Module::Install;

RTx('RT-Extension-AddAdminCcsOnQueueChange');

name            ('RT-Extension-AddAdminCcsOnQueueChange');
all_from        ('lib/RT/Extension/AddAdminCcsOnQueueChange.pm');
abstract        ('On queue change, adds queue AdminCcs as ticket AdminCcs');
author          ('Kevin Riggle <kevinr@bestpractical.com>');
license         ('GPL version 2');

sign;
&WriteAll;
