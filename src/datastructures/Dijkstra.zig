const std = @import("std");
const grp = @import("Graph.zig");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const Allocator = std.mem.Allocator;
const Order = std.math.Order;
const print = std.debug.print;
const Graph = grp.Graph();
const Vertex = Graph.Vertex;

pub fn Dijkstra(graph: *Graph, start_name: []const u8) !void {
    const start_vertex = try graph.getVertex(start_name);
    if (start_vertex) |start| {
        for (graph.vertices) |*vertex| {
            vertex.dist = std.math.maxInt(usize);
            vertex.prev = null;
        }

        start.dist = 0;

        var pq = std.PriorityQueue(*Vertex, void, compareVertices).init(graph.allocator, {});
        defer pq.deinit();

        try pq.add(start);

        while (pq.count() > 0) {
            const current_vertex = pq.remove();

            var edge = current_vertex.adj_list;
            while (edge) |current_edge| {
                const neighbor = current_edge.dest;
                const alt_dist = current_vertex.dist.? + current_edge.weight;

                if (alt_dist < neighbor.dist.?) {
                    neighbor.dist = alt_dist;
                    neighbor.prev = current_vertex;

                    try pq.add(neighbor);
                }
                edge = current_edge.next;
            }
        }
    } else {
        return error.VertexNotFound;
    }
}

fn compareVertices(_: void, a: *Vertex, b: *Vertex) Order {
    const dist_a = a.dist orelse std.math.maxInt(usize);
    const dist_b = b.dist orelse std.math.maxInt(usize);

    return std.math.order(dist_a, dist_b);
}

// pub fn BreadthFirstSearch(self: *Self, startNode: usize) void {
//     var visited = try self.allocator.alloc(bool, self.graph.capacity);
//     defer self.allocator.free(visited);
//     @memset(visited, false);
//
//     var prev = try self.allocator.alloc(isize, self.graph.capacity);
//     defer self.allocator.free(prev);
//     @memset(prev, -1);
//
//     const buffertype = std.fifo.LinearFifoBufferType.Dynamic;
//     var queue = try std.fifo.LinearFifo(usize, buffertype);
//     defer queue.deinit();
//
//     try queue.enqueue(startNode);
//     visited[startNode] = true;
//
//     while (queue.dequeuable()) {
//
//     }
//
// }
