function eval() {
    for (y = 0; y <= my; y++)
        for (x = 0; x <= mx; x++)
            if (s[x,y] == 35)
                if (s[x,y-1] == 35 \
                &&  s[x,y+1] == 35 \
                &&  s[x-1,y] == 35 \
                &&  s[x+1,y] == 35)
                    a += x * y
    print a
    exit 0
}

function out() {
    if (x == 10) {
        my = ++vy
        mx = vx > mx ? vx : mx
        vx = 0
    } else {
        s[vx++,vy] = x
    }
}

{
    l = split($0,t,",")
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    os = 0
    i  = 0
    vx = 0
    vy = 0
    while (op < 99) {
        op  = p[i]
        xm  = int(op/100)   % 10
        ym  = int(op/1000)  % 10
        zm  = int(op/10000) % 10
        op %= 100
        x   = xm == 1 ? p[i+1] : xm == 2 ? p[p[i+1]+os] : p[p[i+1]]
        y   = ym == 1 ? p[i+2] : ym == 2 ? p[p[i+2]+os] : p[p[i+2]]
        rx  = xm ? p[i+1]+os : p[i+1]
        rz  = zm ? p[i+3]+os : p[i+3]
        if      (op == 1) { p[rz] = x + y;  i += 4 }
        else if (op == 2) { p[rz] = x * y;  i += 4 }
        else if (op == 3) { p[rx] = inp;    i += 2 }
        else if (op == 4) { out();          i += 2 }
        else if (op == 5) { i =  x ? y :    i +  3 }
        else if (op == 6) { i = !x ? y :    i +  3 }
        else if (op == 7) { p[rz] = x <  y; i += 4 }
        else if (op == 8) { p[rz] = x == y; i += 4 }
        else if (op == 9) { os += x;        i += 2 }
    }
    eval()
}
