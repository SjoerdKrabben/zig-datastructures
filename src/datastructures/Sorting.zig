const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const Allocator = std.mem.Allocator;

const print = std.debug.print;

pub fn Sort(comptime T: type) type {
    return struct {
        const Self = @This();

        pub fn insertionSort(array: []T, _: usize, _: usize) void {
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

        pub fn selectionSort(array: []T, _: usize, _: usize) void {
            for (array, 0..) |_, i| {
                var min_index = i;

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

        pub fn quickSort(array: []T, low: usize, high: usize) void {
            if (low < high) {
                const pivot_index = partition(array, low, high);

                if (pivot_index > 0) {
                    quickSort(array, low, pivot_index - 1);
                }
                quickSort(array, pivot_index + 1, high);
            }
        }

        fn partition(array: []T, low: usize, high: usize) usize {
            const mid = low + (high - low) / 2;

            if (array[low] > array[mid]) swap(array, low, mid);
            if (array[low] > array[high]) swap(array, low, high);
            if (array[mid] > array[high]) swap(array, mid, high);

            const pivot = array[mid];
            swap(array, mid, high);

            var i = low;
            for (i..high) |j| {
                if (array[j] < pivot) {
                    swap(array, j, i);
                    i += 1;
                }
            }

            swap(array, i, high);
            return i;
        }

        fn swap(array: []T, a: usize, b: usize) void {
            const temp = array[a];
            array[a] = array[b];
            array[b] = temp;
        }

        pub fn mergeSort(array: []T, left: usize, right: usize) void {
            if (left < right) {
                const mid: usize = left + (right - left) / 2;

                mergeSort(array, left, mid);
                mergeSort(array, mid + 1, right);

                merge(array, left, mid, right) catch |err| print("Merge failed: {}", .{err});
            }
        }

        fn merge(array: []T, left: usize, mid: usize, right: usize) Allocator.Error!void {
            const allocator: Allocator = std.heap.page_allocator;
            const n1 = mid - left + 1;
            const n2 = right - mid;

            var L: []T = try allocator.alloc(T, n1);
            defer allocator.free(L);

            var R: []T = try allocator.alloc(T, n2);
            defer allocator.free(R);

            for (0..n1) |i| {
                L[i] = array[left + i];
            }
            for (0..n2) |i| {
                R[i] = array[mid + 1 + i];
            }

            var i: usize = 0;
            var j: usize = 0;
            var k: usize = left;
            while (i < n1 and j < n2) {
                if (L[i] <= R[j]) {
                    array[k] = L[i];
                    i += 1;
                } else {
                    array[k] = R[j];
                    j += 1;
                }
                k += 1;
            }

            while (i < n1) {
                array[k] = L[i];
                i += 1;
                k += 1;
            }

            while (j < n2) {
                array[k] = R[j];
                j += 1;
                k += 1;
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

test "quicksort sorts integer array" {
    const sorter = Sort(i32);
    var arr = [6]i32{ 5, 2, 9, 1, 5, 6 };

    sorter.quickSort(arr[0..], 0, arr.len - 1);

    const expected = [_]i32{ 1, 2, 5, 5, 6, 9 };
    try std.testing.expectEqualSlices(i32, expected[0..], arr[0..]);
}

test "parallel mergesort sorts integer array" {
    const sorter = Sort(i32);
    var arr = [6]i32{ 5, 2, 9, 1, 5, 6 };

    sorter.mergeSort(arr[0..], 0, arr.len - 1);

    const expected = [_]i32{ 1, 2, 5, 5, 6, 9 };
    try std.testing.expectEqualSlices(i32, expected[0..], arr[0..]);
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

test "quicksort sorts float array" {
    const sorter = Sort(f32);
    var arr = [6]f32{ 5.5, 2.2, 9.9, 1.1, 5.5, 6.6 };

    sorter.quickSort(arr[0..], 0, arr.len - 1);

    const expected = [6]f32{ 1.1, 2.2, 5.5, 5.5, 6.6, 9.9 };
    try std.testing.expectEqualSlices(f32, expected[0..], arr[0..]);
}

test "parallel mergesort sorts float array" {
    const sorter = Sort(f32);
    var arr = [_]f32{ 5.5, 2.2, 9.9, 1.1, 5.5, 6.6 };

    sorter.mergeSort(arr[0..], 0, arr.len - 1);

    const expected = [_]f32{ 1.1, 2.2, 5.5, 5.5, 6.6, 9.9 };
    try std.testing.expectEqualSlices(f32, expected[0..], arr[0..]);
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

test "quicksort works with empty array" {
    const sorter = Sort(i32);
    var arr: [0]i32 = [_]i32{};

    sorter.quickSort(arr[0..], 0, arr.len);

    const expected: [0]i32 = [_]i32{};
    try std.testing.expectEqualSlices(i32, expected[0..], arr[0..]);
}

test "parallel mergesort works with empty array" {
    const sorter = Sort(i32);
    var arr: [0]i32 = [_]i32{};

    sorter.mergeSort(arr[0..], 0, arr.len);

    const expected: [0]i32 = [_]i32{};
    try std.testing.expectEqualSlices(i32, expected[0..], arr[0..]);
}
