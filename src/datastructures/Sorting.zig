const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const print = std.debug.print;

pub fn Sort(comptime T: type) type {
    return struct {
        const Self = @This();

        pub fn insertionSort(array: []T) void {
            if (array.len < 2) return;

            for (1..array.len) |i| {
                const key: T = array[i];
                var j: usize = i;

                while (j > 0 and array[j - 1] > key) : (j -= 1) {
                    array[j] = array[j - 1];
                }

                array[j] = key;
            }
        }

        pub fn selectionSort(array: []T) void {
            var min_index: usize = 0;
            for (array, 0..) |_, i| {
                min_index = i;

                for (i + 1..array.len) |j| {
                    if (array[j] < array[min_index]) {
                        min_index = j;
                    }
                }

                if (min_index != i) {
                    const temp: T = array[i];
                    array[i] = array[min_index];
                    array[min_index] = temp;
                }
            }
        }
    };
}

test "insertionSort sorts integer array" {
    const sorter = Sort(i32);
    var arr: [6]i32 = [_]i32{ 5, 2, 9, 1, 5, 6 };

    sorter.insertionSort(arr[0..]);

    const expected: [6]i32 = [_]i32{ 1, 2, 5, 5, 6, 9 };
    try testing.expectEqualSlices(i32, expected[0..], arr[0..]);
}

test "selectionSort sorts integer array" {
    const sorter = Sort(i32);
    var arr: [6]i32 = [_]i32{ 5, 2, 9, 1, 5, 6 };

    sorter.selectionSort(arr[0..]);

    const expected: [6]i32 = [_]i32{ 1, 2, 5, 5, 6, 9 };
    try testing.expectEqualSlices(i32, expected[0..], arr[0..]);
}

test "insertionSort sorts float array" {
    const sorter = Sort(f32);
    var arr: [6]f32 = [_]f32{ 5.5, 2.2, 9.9, 1.1, 5.5, 6.6 };

    sorter.insertionSort(arr[0..]);

    const expected: [6]f32 = [_]f32{ 1.1, 2.2, 5.5, 5.5, 6.6, 9.9 };
    try testing.expectEqualSlices(f32, expected[0..], arr[0..]);
}

test "selectionSort sorts float array" {
    const sorter = Sort(f32);
    var arr: [6]f32 = [_]f32{ 5.5, 2.2, 9.9, 1.1, 5.5, 6.6 };

    sorter.selectionSort(arr[0..]);

    const expected: [6]f32 = [_]f32{ 1.1, 2.2, 5.5, 5.5, 6.6, 9.9 };
    try testing.expectEqualSlices(f32, expected[0..], arr[0..]);
}

test "insertionSort works with empty array" {
    const sorter = Sort(i32);
    var arr: [0]i32 = [_]i32{};

    sorter.insertionSort(arr[0..]);

    const expected: [0]i32 = [_]i32{};
    try testing.expectEqualSlices(i32, expected[0..], arr[0..]);
}

test "selectionSort works with empty array" {
    const sorter = Sort(i32);
    var arr: [0]i32 = [_]i32{};

    sorter.selectionSort(arr[0..]);

    const expected: [0]i32 = [_]i32{};
    try testing.expectEqualSlices(i32, expected[0..], arr[0..]);
}
