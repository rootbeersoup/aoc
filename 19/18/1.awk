BEGIN { 
    FS = ""
    ep = 0
    dp = 0
    delete q
}

{
    for (i = 1; i <= NF; i++) {
        v[i,NR] = $i
        if ($i ~ /[a-z]/)
            k[$i]  = i SUBSEP NR
        else if ($i == "@") 
            origin = i SUBSEP NR
    }
}

END {
    for (i in k)
        all_keys = all_keys i
    print collect("@", all_keys)
}

function collect(c,keys,    cidx,rk,i,d,nk,res) {
    if (!keys) return 0
    if ((c,keys) in cache) return cache[c,keys]
    res = 9999
    split(reachable(c,keys),rk,"")
    for (i in rk) {
        nk = keys
        sub(rk[i],"",nk)
        d = distance(c,rk[i]) + collect(rk[i],nk)
        res = res > d ? d : res
    }
    cache[c,keys] = res
    return res
}

function distance(a,b) {
    if (!((a,b) in dist))
        map_distance(a == "@" ? origin : k[a],
                     b == "@" ? origin : k[b])
    return dist[a,b]
}

function reachable(o,keys,      c,coords,cx,cy,s,n,i) {
    if (keys in r) return r[keys]
    enqueue(o == "@" ? origin : k[o])
    while (length(q)) {
        c = dequeue()
        split(c,coords,SUBSEP)
        cx = coords[1]
        cy = coords[2]
        n[0] = cx+1 SUBSEP cy
        n[1] = cx-1 SUBSEP cy
        n[2] = cx   SUBSEP cy+1
        n[3] = cx   SUBSEP cy-1
        for (i in n) {
            if (!s[n[i]] && v[n[i]] != "#") {
                s[n[i]] = 1
                if (v[n[i]] ~ /[A-Z]/ && keys !~ tolower(v[n[i]])) {
                    enqueue(n[i])
                } else if (v[n[i]] ~ /[a-z]/) {
                    if (keys ~ v[n[i]])
                        r[keys] = r[keys] v[n[i]]
                    else
                        enqueue(n[i])
                } else if (v[n[i]] ~ /\.|@/) {
                    enqueue(n[i])
                }
            }
        }
    }
    empty_queue()
    return r[keys]
}

function map_distance(a,b,     c,coords,cx,cy,steps,s,n,i) {
    if (a == b) {
        dist[v[a],v[b]] = 0
        dist[v[b],v[a]] = 0
        return
    }
    enqueue(a)
    steps[a] = 0
    while (length(q)) {
        c = dequeue()
        if (c == b) {
            dist[v[a],v[b]] = steps[b]
            dist[v[b],v[a]] = steps[b]
            empty_queue()
        } else {
            split(c,coords,SUBSEP)
            cx = coords[1]
            cy = coords[2]
            n[0] = cx+1 SUBSEP cy
            n[1] = cx-1 SUBSEP cy
            n[2] = cx   SUBSEP cy+1
            n[3] = cx   SUBSEP cy-1
            for (i in n) {
                if (!s[n[i]] && v[n[i]] != "#") {
                    s[n[i]] = 1
                    steps[n[i]] = steps[c] + 1
                    enqueue(n[i])
                }
            }
        }
    }
}

function enqueue(x) {
    q[ep++] = x
}

function dequeue() {
    if (!length(q))
        return 0
    else {
        ret = q[dp]
        delete q[dp++]
        return ret
    }
}

function empty_queue(i) {
    for (i in q)
        delete q[i]
    ep = 0
    dp = 0
}
