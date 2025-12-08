const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const print = std.debug.print;

pub fn insertionSort(array: []i32) void {
    for (1..array.len) |i| {
        const key: i32 = array[i];
        var j: usize = i;

        while (j > 0 and array[j - 1] > key) : (j -= 1) {
            array[j] = array[j - 1];
        }
        array[j] = key;
    }
}

test "Test insertionSort" {
    var a: i32 = undefined;
    var b: i32 = undefined;
    var c: i32 = undefined;
    var d: i32 = undefined;
    var e: i32 = undefined;
    var array: [5]i32 = [_]i32{ 64, 25, 12, 22, 11 };

    a,b,c,d,e = array;
    print("Originele array: {d}, {d}, {d}, {d}, {d}\n", .{a,b,c,d,e});
    insertionSort(&array);

    a,b,c,d,e = array;
    print("Gesorteerde array: {d}, {d}, {d}, {d}, {d}\n", .{a,b,c,d,e});

    var data: [5]i32 = [_]i32{ 5, 3, 4, 1, 2 };
    insertionSort(&data);
    for (1..5) |n| {
        try testing.expect(data[n - 1] == n);
    }
}
