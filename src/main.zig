//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const dl = @import("1_DynamicList/DynamicList.zig");
const print = std.debug.print;
var selection: u8 = 9;

pub fn main() !void {
    const options = [5][]const u8{ "1: DynamicList", "2: DoublyLinkedList", "3: Stack", "4: Queue", "5: PriorityQueue" };

    try showMain(options[0..5]);

    while (selection != 0) {
        switch (selection) {
            1 => showDynamicList(),
            2 => showDoublyLinkedList(),
            else => break,
        }
    }
}

fn showMain(opts: *const [5][]const u8) !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    var inputBuffer: [8]u8 = undefined;

    try stdout.print("\n", .{});
    try stdout.print("Kies uit de verschillende datastructuren en algoritmes om ze te testen: \n", .{});
    try stdout.print("\n", .{});
    for (opts) |option| {
        print("{s} \n", .{option});
    }
    try stdout.print("\n", .{});
    try stdout.print("Kies een optie: ", .{});

    const input = try stdin.readUntilDelimiterOrEof(&inputBuffer, '\n');

    if (input) |val| {
        if (val.len == 0) {
            try stdout.print("Je hebt niets ingevuld!\n", .{});
        } else {
            const byteValue: []u8 = val[0..1];
            const index = try std.fmt.parseInt(usize, byteValue, 10) - 1;
            try stdout.print("Je hebt {s} gekozen!\n", .{opts[index]});
        }
    }
}

fn showDynamicList() void {}
fn showDoublyLinkedList() void {}
