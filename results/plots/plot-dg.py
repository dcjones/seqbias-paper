#!/usr/bin/env python

'''
This a simple program to plot directed graphs in a compact, readable fashion,
similar to circos (http://circos.ca/).
'''

import pydot
import cairo
import argparse
from math        import pi, radians, sin, cos, atan2, sqrt
from collections import defaultdict


def guess_radius():
    return min(args.width, args.height) / 2.0 - 50


def draw_nodes(G, ctx):
    '''
    Draw labeled nodes in a big circle, given a pydot graph and a cairo context
    object.
    '''

    us = [u for u in G.get_nodes() if u.get_label() is not None]
    us.sort(key = lambda u: -int(u.get_label().strip('"')))

    n = len(us)
    r = guess_radius()
    k = (2.0 * pi - radians(args.gap)) / n

    for (i, u) in enumerate(us):
        label = u.get_label().strip('"')
        style = u.get_style().strip('"')

        theta = (i + 0.5) * k + radians(args.gap) / 2.0

        x, y = r * sin(theta), r * cos(theta)

        ctx.arc(x, y, args.node_rad, 0.0, 2 * pi)

        if style == 'solid':
            ctx.stroke_preserve()
            ctx.arc(x, y, args.node_rad, 0.0, 2 * pi)
            ctx.fill()
        else:
            ctx.stroke()



        xt = (r + 2 * args.node_rad) * sin(theta)
        yt = (r + 2 * args.node_rad) * cos(theta)

        ctx.save()

        ctx.translate(xt, yt)
        ctx.rotate(pi - theta)

        ctx.move_to(-ctx.text_extents(label)[4] / 2.0, 0)
        ctx.text_path(label)
        ctx.fill()

        ctx.restore()

        # TODO: draw label


def ed((x0, y0), (x1, y1)):
    ''' Euclidean distance. '''
    return sqrt((x0 - x1) ** 2 + (y0 - y1) ** 2)


def draw_edges(G, ctx):
    us = [u for u in G.get_nodes() if u.get_label() is not None]
    us.sort(key = lambda u: -int(u.get_label().strip('"')))

    node_pos = dict(zip([u.get_name() for u in us], range(len(us))))

    n = len(us)
    r = guess_radius()
    k = (2.0 * pi - radians(args.gap)) / n


    for e in G.get_edges():

        u = e.get_source()
        theta_u = (node_pos[u] + 0.5 - 0.15) * k + radians(args.gap) / 2.0
        (xu, yu) = r * sin(theta_u), r * cos(theta_u)

        v = e.get_destination()
        theta_v = (node_pos[v] + 0.5 + 0.15) * k + radians(args.gap) / 2.0
        (xv, yv) = r * sin(theta_v), r * cos(theta_v)

        theta = (theta_u + theta_v) / 2.0


        # do some fancy things to come up with reasonable control points for
        # bazier curves
        d = abs(node_pos[u] - node_pos[v])

        # totally ad-hoc formlae, here:
        delta = r * (1.0 - (7.0 * (d) / n))

        #w = ed((xu, yu), (xv, yv)) / 2.0
        w =  5.0 / d

        omega = atan2(w, delta)
        xa, ya = delta * sin(theta + omega), delta * cos(theta + omega)
        xb, yb = delta * sin(theta - omega), delta * cos(theta - omega)

        if node_pos[u] < node_pos[v]:
            ((xa, ya), (xb, yb)) = ((xb, yb), (xa, ya))


        # nudge source, so the line from the edge of the circe, not the center
        m = args.node_rad / ed((xa, ya), (xu, yu))
        xu = (1.0 - m) * xu + m * xa
        yu = (1.0 - m) * yu + m * ya

        ctx.move_to(xu, yu)

        # nudge destination
        m = args.node_rad / ed((xb, yb), (xv, yv))
        xv = (1.0 - m) * xv + m * xb
        yv = (1.0 - m) * yv + m * yb

        ctx.curve_to(xa, ya, xb, yb, xv, yv)

        ctx.stroke()


        # draw arrows
        draw_arrow(ctx, (xb, yb), (xv, yv))


def draw_arrow(ctx, (xb, yb), (xv, yv)):

    theta = atan2(yv - yb, xv - xb)

    d = ed((xb, yb), (xv, yv))

    off = args.arrow_dim1 / d

    xc, yc = off * xb + (1.0 - off) * xv, off * yb + (1.0 - off) * yv

    x_adj = args.arrow_dim2 * sin(theta)
    y_adj = args.arrow_dim2 * cos(theta)

    ctx.move_to(xv, yv)
    ctx.line_to(xc - x_adj, yc + y_adj)
    ctx.line_to(xc + x_adj, yc - y_adj)
    ctx.close_path()
    ctx.fill()


def compute_num_params(G):
    '''
    Compute the number of parameters needed to specify the model respresented
    by the graph.
    '''

    node_params = defaultdict(lambda: 0)

    for u in G.get_nodes():
        name  = u.get_name()

        if u.get_style() is None: continue
        elif u.get_style().strip('"') == 'solid':
            node_params[name] = 4


    for e in G.get_edges():
        name = e.get_destination()
        node_params[name] *= 4

    for name in node_params:
        node_params[name] -= 1

    return 2 * sum(node_params.values())


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('graph_fn', metavar = 'graph.dot')
    ap.add_argument('-o', '--output', dest = 'out_fn', default = 'g.svg')
    ap.add_argument('-W', '--width',  default = 500, type = int)
    ap.add_argument('-H', '--height', default = 500,  type = int)
    ap.add_argument('--gap', default = 25, type = float)
    ap.add_argument('--node_rad', default = 10, type = float)
    ap.add_argument('--font-size', default = 18, type = float)
    ap.add_argument('--arrow_dim1', default = 10, type = float)
    ap.add_argument('--arrow_dim2', default = 5, type = float)
    ap.add_argument('--font-face', default = 'Univers LT Std', type = str)

    global args
    args = ap.parse_args()

    G = pydot.graph_from_dot_file(args.graph_fn)

    surface = cairo.SVGSurface(args.out_fn, args.width, args.height)

    ctx = cairo.Context(surface)
    ctx.translate(args.width / 2.0, args.height / 2.0)

    ctx.select_font_face(args.font_face,
                         cairo.FONT_SLANT_NORMAL,
                         cairo.FONT_WEIGHT_NORMAL)
    ctx.set_font_size(args.font_size)

    draw_nodes(G, ctx)
    draw_edges(G, ctx)

    print(compute_num_params(G))


if __name__ == '__main__':
    main()

