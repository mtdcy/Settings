#! /usr/bin/perl -w
# xiaofangxu@iqoo.com  2011.5

use Getopt::Long;
use File::Basename;

sub usage {
    $x = basename $0;
    print <<EOF
usage: $x [-i seconds] [-h] pid
options:
      -i,--interval  repeat memory statistics on specified time interval
      -h,--help      print this help
EOF
}

$repeat_timer = 0;
GetOptions("i|internal=i", \$interval, "h|help", \$help) or die "getopt fail: $!\n";
$repeat_timer = $interval if $interval;

if ($help) {
    usage;
    exit 0;
}

if (@ARGV != 1) {
    usage;
    exit 1;
}
$pid = $ARGV[0];

printf "%-10ssharedDirty  privateDirty | total_used   total_free\n", "rss($pid)";
do {
    $first_check = 1;
    $rss = 0;
    $shared_dirty = 0;
    $private_dirty = 0;
    $sys_total = 0;
    $sys_free = 0;
    $private_clean = 0;

    open INF, "adb shell cat /proc/$pid/smaps |" or die "can't fork adb: $!\n";
    while (<INF>) {
        if ($first_check) {
            die "can't find pid = $pid process!\n" unless /^[0-9a-fA-F]{8}/;
            $first_check = 0;
        }

        if (/^Rss:\s+(\d+)/) {
            $rss += $1;
        } elsif (/^Shared_Dirty:\s+(\d+)/) {
            $shared_dirty += $1;
        } elsif (/^Private_Dirty:\s+(\d+)/) {
            $private_dirty += $1;
        } elsif(/^Private_Clean:\s+(\d+)/){
            $private_clean += $1;
        }
    }
    
    close INF;
    open MEMINFO, "adb shell cat /proc/meminfo |" or die "can't fork adb: $!\n";

    # total
    $_  = <MEMINFO>;
    die "invalid meminfo output! maybe adb fail.\n" unless $_ && /MemTotal:\s+(\d+)\s+/;
    $sys_total = int $1;

    # free
    $_  = <MEMINFO>;
    die "invalid meminfo output!\n" unless /MemFree:\s+(\d+)\s+/;
    $sys_free += int $1;

    # buffers
    $_  = <MEMINFO>;
    die "invalid meminfo output!\n" unless /Buffers:\s+(\d+)\s+/;
    $sys_free += int $1;

    # cache
    $_  = <MEMINFO>;
    die "invalid meminfo output!\n" unless /Cached:\s+(\d+)\s+/;
    $sys_free += int $1;
    
		close MEMINFO;

    $total_used = $sys_total - $sys_free;
    $private_dirty += $private_clean;
		
    printf("%-10s%-13s%-12s | %-13s%-10s\n", "${rss}K", "${shared_dirty}K",
        "${private_dirty}K", "${total_used}K", "${sys_free}K");

    sleep($repeat_timer);

} while ($repeat_timer > 0);


exit 0;

