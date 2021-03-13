const std = @import("std");
const os = std.os;

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = &gpa.allocator;
    const addressList = getAddressList(allocator);
}

fn getAddressList(allocator: *std.mem.Allocator) !*os.addrinfo {
    // os.SOCK_STREAM (tcp)
    // os.SOCK_DGRAM (udp)
    const port = "9999";
    const port_c = try std.fmt.allocPrint(allocator, "{}\x00", .{port});
    defer allocator.free(port_c);

    const sys = std.os.system;
    const hints = os.addrinfo{
        .flags = sys.AI_NUMERICSERV,
        .family = os.AF_UNSPEC,
        .socktype = os.SOCK_STREAM,
        .protocol = os.IPPROTO_TCP,
        .canonname = null,
        .addr = null,
        .addrlen = 0,
        .next = null,
    };

    var res: *os.addrinfo = undefined;

    const rc = sys.getaddrinfo(null, port_c, &hints, &res);

    if (rc != 0) {
        print("Error getaddrinfo {}", .{rc});
    }

    defer sys.freeaddrinfo(res);

    std.debug.print("Result: {}", .{res});
}
