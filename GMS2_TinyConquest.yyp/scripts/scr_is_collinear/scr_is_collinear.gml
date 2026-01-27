function scr_is_collinear(x1, y1, x2, y2, x3, y3)
{
    return (x2 - x1) * (y3 - y1) == (y2 - y1) * (x3 - x1);
}