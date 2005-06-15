use inc::Module::Install;

RTx('RT-Extension-AddAdminCcsOnQueueChange');

name            ('RT-Extension-AddAdminCcsOnQueueChange');
abstract        ('On queue change, adds queue AdminCcs as ticket AdminCcs');
author          ('Kevin Riggle <kevinr@bestpractical.com>');
version_from    ('lib/RT/Extension/AddAdminCcsOnQueueChange.pm');
license         ('GPL version 2');

&WriteAll;
