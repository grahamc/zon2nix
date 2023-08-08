const std = @import("std");
const StringHashMap = std.StringHashMap;

const Dependency = @import("Dependency.zig");

pub fn write(out: anytype, deps: StringHashMap(Dependency)) !void {
    try out.writeAll(
        \\# generated by zon2nix (https://github.com/figsoda/zon2nix)
        \\
        \\{ linkFarm, fetchzip }:
        \\
        \\linkFarm "zig-packages" [
        \\
    );

    var iter = deps.iterator();
    while (iter.next()) |entry| {
        const key = entry.key_ptr.*;
        const dep = entry.value_ptr.*;
        try out.print(
            \\  {{
            \\    name = "{s}";
            \\    path = fetchzip {{
            \\      url = "{s}";
            \\      hash = "{s}";
            \\    }};
            \\  }}
            \\
        , .{ key, dep.url, dep.nix_hash });
    }

    try out.writeAll("]\n");
}