# snowid

A Decentralized, K-Ordered Unique ID Generator library in C.

It generates 12b-bit k-ordered id's (time-ordered lexically). It can be run on each node in your
infrastructure and it will generate conflict-free id's on-demand without coordination.

## Design

#### UUID format (128 bits)

```
{timestamp:64, worker_id:48, seq: 16}
```

* `timestamp` - unix timestamp (millisecond timestamp resolution)
* `worker_id` - pulled from a network interface a 48-bit MAC address
* `seq` - incremented each time id is requested in the same millisecond. This means each server can produce 2^16 - 1 unique id's per millisecond without overflow.

#### Config

A simple text based config file with below fields:

* `interface` - Set to available network interface to pull a 48-bit mac address as worker id.
* `timestamp_path` - To periodically save the current time. When snow_init() is called and if it detects
that this file contains timestamp in the future or distant past then it refuses to generate id. This prevents problematic id's (that might break time-orderness) from getting distributed.
* `allowable_downtime` - Safeguard to prevent id generation if it detects it hasn't been run in a long time
since this might be an indication that the system clock has been skewed far into the future.

Example:
```
interface="en0"
timestamp_path="/data/snowid/timestamp.out"
allowable_downtime=1665373570
```

## Credits

The idea/design is borrowed from BMC's (formerly Boundary) flake server written in Erlang.
More details are in the original [post](http://archive.is/2015.07.08-082503/http://www.boundary.com/blog/2012/01/flake-a-decentralized-k-ordered-unique-id-generator-in-erlang/).