const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn Graph() type {
    return struct {
        const Self = @This();

        pub const Vertex = struct {
            const InnerSelf = @This();

            name: ?[]const u8,
            prev: ?*Vertex,
            dist: ?usize,
            adj_list: ?*Edge,
        };

        const Edge = struct {
            next: ?*Edge,
            dest: *Vertex,
            weight: usize,
        };

        allocator: Allocator,
        vertices: []Vertex,
        capacity: usize = 0,

        pub fn init(allocator: Allocator, capacity: usize) Allocator.Error!Self {
            const vertices = try allocator.alloc(Vertex, capacity);

            for (vertices) |*vertex| {
                vertex.* = Vertex{ .name = null, .prev = null, .dist = null, .adj_list = null };
            }

            return Self{ .vertices = vertices, .allocator = allocator, .capacity = capacity };
        }

        pub fn deinit(self: *Self) void {
            for (self.vertices) |*vertex| {
                var edge = vertex.adj_list;
                while (edge) |current| {
                    const next = current.next;
                    self.allocator.destroy(current);
                    edge = next;
                }
                vertex.adj_list = null;
                vertex.name = null;
                vertex.prev = null;
                vertex.dist = null;
            }
            self.allocator.free(self.vertices);
        }

        pub fn addEdge(self: *Self, from: *Vertex, dest: *Vertex, weight: usize) Allocator.Error!void {
            const new_edge = try self.allocator.create(Edge);

            new_edge.* = Edge{
                .next = null,
                .dest = dest,
                .weight = weight,
            };

            if (from.adj_list == null) {
                from.adj_list = new_edge;
            } else {
                var current = from.adj_list;

                while (current) |edge| {
                    const next = edge.next;
                    if (next == null) {
                        edge.next = new_edge;
                        return;
                    }
                    current = next;
                }
            }
        }

        pub fn addUndirectedEdge(self: *Self, from: *Vertex, to: *Vertex, weight: usize) !void {
            try self.addEdge(from, to, weight);
            try self.addEdge(to, from, weight);
        }

        pub fn createVertex(self: *Self, name: []const u8) !*Vertex {
            var index = getHash(name) % self.capacity;
            var probes: usize = 0;

            while (true) {
                const vertex = &self.vertices[index];

                if (vertex.name == null) {
                    vertex.*.name = name;
                    return vertex;
                } else if (std.mem.eql(u8, vertex.name.?, name)) {
                    // vertex.value = value;
                    return vertex;
                } else {
                    probes += 1;
                    if (probes >= self.capacity) {
                        return error.GraphIsFull;
                    }

                    index = nextIndex(self, index);
                }
            }
        }

        pub fn getVertex(self: *Self, name: []const u8) !?*Vertex {
            var index = getHash(name) % self.capacity;
            var probes: usize = 0;

            while (true) {
                const vertex = &self.vertices[index];

                if (vertex.name == null) {
                    return null;
                }

                if (std.mem.eql(u8, vertex.name.?, name)) {
                    return vertex;
                } else {
                    probes += 1;
                    if (probes >= self.capacity) {
                        return null;
                    }

                    index = nextIndex(self, index);
                }
            }
        }

        fn getHash(key: []const u8) usize {
            var hash: usize = 0;
            const P: usize = 31;
            for (key) |byte| {
                hash = hash * P + byte;
            }
            return hash;
        }

        fn nextIndex(self: *Self, index: usize) usize {
            return (index + 1) % self.capacity;
        }
    };
}

test "Graph operations" {
    const allocator = testing.allocator;

    var G = try Graph().init(allocator, 5);
    defer G.deinit();

    const v1 = try G.createVertex("Vertex1");
    const v2 = try G.createVertex("Vertex2");
    const v3 = try G.createVertex("Vertex3");
    const v4 = try G.createVertex("Vertex4");
    const v5 = try G.createVertex("Vertex5");

    const vx3 = try G.getVertex("Vertex3") orelse unreachable;
    try testing.expectEqualStrings(v3.name.?, vx3.name.?);

    try G.addEdge(v1, v2, 12);
    try G.addEdge(v1, v4, 87);
    try G.addEdge(v2, v5, 11);
    try G.addEdge(v3, v1, 19);
    try G.addEdge(v4, v2, 23);
    try G.addEdge(v4, v3, 10);
    try G.addEdge(v5, v4, 43);
}
