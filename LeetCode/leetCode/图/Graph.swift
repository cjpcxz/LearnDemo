//
//  Graph.swift
//  leetCode
//
//  Created by 陈晶泊 on 2022/10/25.
//

import Foundation
//934. 最短的桥
func shortestBridge(_ grid: [[Int]]) -> Int {
    let n = grid.count
    var grids = grid
    let dirs = [(-1,0),(1,0),(0,-1),(0,1)]
    var queue = [(Int,Int)]()
    func updateGrid(_ grid: inout [[Int]],_ i:Int,_ j:Int,_ queue:inout [(Int,Int)]) {
        guard case 0..<grid.count = i,case 0..<grid.count = j,grid[i][j] == 1 else {
            return
        }
        grid[i][j]=2
        queue.append((i,j))
        updateGrid(&grid, i-1, j, &queue)
        updateGrid(&grid, i+1, j, &queue)
        updateGrid(&grid, i, j-1, &queue)
        updateGrid(&grid, i, j+1, &queue)
    }
    
    for i in 0..<n {
        for j in 0..<n where grid[i][j] == 1{
            updateGrid(&grids, i, j,&queue)
            var step = 0
            while !queue.isEmpty {
                let count = queue.count
                for _ in 0..<count {
                    let frist = queue.removeFirst()
                    for dir in dirs {
                        let row = dir.0 + frist.0,col = dir.1 + frist.1
                        guard case 0..<n = row,case 0..<n = col else {
                            continue
                        }
                        if grids[row][col] == 0 {
                            grids[row][col] = 2
                            queue.append((row,col))
                        } else if grids[row][col] == 1 {
                            return step
                        }
                    }
                }
                step += 1
            }
            
        }
    }
    return 0
}

///Dijkstra算法
//882. 细分图中的可到达节点 //[[0,2,3],[0,4,4],[2,3,8],[1,3,5],[0,3,9],[3,4,6],[0,1,5],[2,4,6],[1,2,3],[1,4,1]]
func reachableNodes(_ edges: [[Int]], _ maxMoves: Int, _ n: Int) -> Int {
    
    func priortyAdd<T>(arr:inout [T],elem:T,comper:(T,T)->Bool) {
        var (i,j,m) = (0,arr.count - 1,0)
        while i < j {
            m = (j - i) >> 1 + i
            //左小于右
            if comper(arr[m], elem) {
                i = m+1
            } else {
                j = m
            }
        }
        arr.insert(elem, at: i)
    }
    
    func dijkstra(grap:[Int:[(Int,Int)]],start:Int)->[Int] {
        var dist = Array(repeating: Int.max, count: n)
        dist[start] = 0
        var pd = [(0,0)]
        while !pd.isEmpty {
            let frist = pd.removeFirst()
            let (x,d) = frist
            if d > dist[x] { continue }
            guard let g = grap[x] else {
                continue
            }
            for (i,j) in g {
                let newDist = d + j
                if newDist < dist[i] {
                    dist[i] = newDist
                    priortyAdd(arr: &pd, elem: (i,newDist)) { elem, elem in
                        elem.1 < elem.1
                    }
                }
            }
        }
        return dist
    }
    var grap = [Int:[(Int,Int)]]()
    grap.reserveCapacity(n)
    for edge in edges where edge.count > 2{
        grap[edge[0]] = (grap[edge[0]] ?? []) + [(edge[1],edge[2] + 1)]
        grap[edge[1]] = (grap[edge[1]] ?? []) + [(edge[0],edge[2] + 1)]
    }
    let dist = dijkstra(grap: grap, start: 0)
    var ans = 0
    for d in dist where d <= maxMoves{
        ans += 1
    }
    for edge in edges {
        let (u,v,cnt) = (edge[0],edge[1],edge[2])
        let a = max(maxMoves - dist[u], 0) //该边有多少被占了的点
        let b = max(maxMoves - dist[v], 0)
        ans += min(a+b,cnt) //去重
    }
    return ans
}

//1697. 检查边长度限制的路径是否存在  ,并查集
func distanceLimitedPathsExist(_ n: Int, _ edgeList: [[Int]], _ queries: [[Int]]) -> [Bool] {
    func find(uf:inout [Int],x:Int) -> Int {
        if uf[x] == x {
            return x
        }
        uf[x] = find(uf: &uf, x: uf[x])
        return uf[x]
    }
    
    func merge(uf:inout [Int],x:Int,y:Int) {
        let x = find(uf: &uf, x: x)
        let y = find(uf: &uf, x: y)
        uf[y] = x
    }
    //边由小变大
    let sorEdges = edgeList.sorted {$0[2] < $1[2]}
    
    var indexs = Array(repeating: 0, count: queries.count)
    for i in 0..<indexs.count {
        indexs[i] = i
    }
    //限制由小到大
    indexs.sort{queries[$0][2] < queries[$1][2]}
    var uf = Array(repeating: 0, count: n)
    for i in 0..<uf.count {
        uf[i] = i
    }
    var res = Array(repeating: false, count: queries.count)
    var k = 0
    for i in indexs {
        while k < sorEdges.count,sorEdges[k][2] < queries[i][2] {
            merge(uf: &uf, x: sorEdges[k][0], y: sorEdges[k][1])
            k += 1
        }
        res[i] = find(uf: &uf, x: queries[i][0]) == find(uf: &uf, x: queries[i][1])
    }
    return res
}

//1971. 寻找图中是否存在路径
func validPath(_ n: Int, _ edges: [[Int]], _ source: Int, _ destination: Int) -> Bool {
    func find(uf:inout [Int],x:Int) -> Int {
        if uf[x] == x {
            return x
        }
        uf[x] = find(uf: &uf, x: uf[x])
        return uf[x]
    }
    
    func merge(uf:inout [Int],x:Int,y:Int) {
        let x = find(uf: &uf, x: x)
        let y = find(uf: &uf, x: y)
        uf[y] = x
    }
    
    var uf = Array(repeating: 0, count: n)
    for i in 1..<n {
        uf[i] = i
    }
    for edge in edges {
        guard find(uf: &uf, x: source) != find(uf: &uf, x: destination) else {
            return true
        }
        merge(uf: &uf, x: edge[0], y: edge[1])
    }
    return find(uf: &uf, x: source) == find(uf: &uf, x: destination)
}
//1129. 颜色交替的最短路径
/**
 [[2,6],[5,0],[5,5],[4,0],[2,0],[1,2],[0,2],[4,2],[1,6],[3,4],[6,1]]
 [[2,0],[2,1],[3,4],[0,4],[2,6],[5,5],[5,2],[4,3],[1,3],[3,1],[1,5],[4,1],[4,4],[2,4],[1,6],[4,0],[5,6],[1,4],[3,3]]
 0 1 5
 0 4
 */
func shortestAlternatingPaths(_ n: Int, _ redEdges: [[Int]], _ blueEdges: [[Int]]) -> [Int] {
    //红---绿
    var arr = Array(repeating: Array(repeating: Int.max, count: n), count: 2)
    var next = Array(repeating: Array(repeating: Set<Int>(), count: n), count: 2)
    _ = redEdges.map { edge in
        next[0][edge[0]].insert(edge[1])
        
    }
    _ = blueEdges.map { edge in
        next[1][edge[0]].insert(edge[1])
    }
    var arrData = [(0,0),(0,1)]
    arr[0][0] = 0
    arr[1][0] = 0
    while !arrData.isEmpty {
        let frist = arrData.removeFirst()
        let x = frist.0,t = frist.1
        for num in next[1 - t][x] {
            if arr[1-t][num] != Int.max {
                continue
            }
            arr[1-t][num] = arr[t][x] + 1
            arrData.append((num,1-t))
        }
    }
    var res = Array(repeating: 0, count: n)
    for i in 0..<n {
        var tmp = min(arr[0][i],arr[1][i])
        if tmp == Int.max {
            tmp = -1
        }
        res[i] = tmp
    }
    return res
}

// 剑指 Offer 47. 礼物的最大价值
/**
 在一个 m*n 的棋盘的每一格都放有一个礼物，每个礼物都有一定的价值（价值大于 0）。你可以从棋盘的左上角开始拿格子里的礼物，并每次向右或者向下移动一格、直到到达棋盘的右下角。给定一个棋盘及其上面的礼物的价值，请计算你最多能拿到多少价值的礼物？

 */

func maxValue(_ grid: [[Int]]) -> Int {
    let a = grid.count,b = grid[0].count
    var dp = Array(repeating: Array(repeating: 0, count: b+1), count: a+1)
    for i in 1...a {
        for j in 1...b {
            dp[i][j] = grid[i-1][j-1] + max(dp[i][j-1],dp[i-1][j])
        }
    }
    return dp[a][b]
}


//1617. 统计子树中城市之间最大距离
/**
 [[1,2],[2,3],[3,4]]
 N
 */
func countSubgraphsForEachDiameter(_ n: Int, _ edges: [[Int]]) -> [Int] {
    var adj = Array(repeating: [Int](), count: n)
    for edge in edges {
        adj[edge[0]-1].append(edge[1]-1)
        adj[edge[1]-1].append(edge[0]-1)
    }
    var res = Array(repeating: 0, count: n-1),diameter = 0
    var mask = 0
    for i in 1..<(1 << n) {
        let begin = Int(log2(Double(i & (~i + 1))))
        diameter = 0
        mask = i
        dfs(begin: begin)
        if mask == 0 && diameter > 0 {
            res[diameter - 1] += 1
        }
    }
    @discardableResult
    func dfs(begin:Int) -> Int {
        var first = 0,second = 0
        mask = mask ^ (1 << begin)
        for vertex in adj[begin] where mask & (1 << vertex) != 0{
            let distance = 1 + dfs(begin: vertex)
            if distance > first {
                second = first
                first = distance
            } else if distance > second {
                second = distance
            }
        }
        diameter = max(diameter,first + second)
        return first
    }
    return res
}

//1263. 推箱子
/**
 游戏地图用大小为 m x n 的网格 grid 表示，其中每个元素可以是墙、地板或者是箱子。

 现在你将作为玩家参与游戏，按规则将箱子 'B' 移动到目标位置 'T' ：

 玩家用字符 'S' 表示，只要他在地板上，就可以在网格中向上、下、左、右四个方向移动。
 地板用字符 '.' 表示，意味着可以自由行走。
 墙用字符 '#' 表示，意味着障碍物，不能通行。
 箱子仅有一个，用字符 'B' 表示。相应地，网格上有一个目标位置 'T'。
 玩家需要站在箱子旁边，然后沿着箱子的方向进行移动，此时箱子会被移动到相邻的地板单元格。记作一次「推动」。
 玩家无法越过箱子。
 返回将箱子推到目标位置的最小 推动 次数，如果无法做到，请返回 -1。
 */
func minPushBox(_ grid: [[Character]]) -> Int {
    let m = grid.count,n = grid[0].count
    var sx = -1,sy = -1,bx = -1,by = -1
    for i in 0..<m {
        for j in 0..<n {
            switch grid[i][j] {
            case "S":
                sx = i
                sy = j
            case "B":
                bx = i
                by = j
            default:break
            }
        }
    }
    
    let d = [0,-1,0,1,0]
    var dp = Array(repeating: Array(repeating: Int.max, count: m * n), count: m * n)
    var queue = [(Int,Int)]()
    dp[sx * n + sy][bx * n + by] = 0
    queue.append((sx * n + sy,bx * n + by))
    while !queue.isEmpty {
        var queue1 = [(Int,Int)]()
        while !queue.isEmpty {
            let temp = queue.removeLast()
            let s1 = temp.0,b1 = temp.1
            let sx1 = s1 / n,sy1 = s1 % n,bx1 = b1 / n,by1 = b1 % n
            guard grid[bx1][by1] != "T" else {
                return dp[s1][b1]
            }
            for i in 0..<4 { //4个不同方向
                let sx2 = sx1 + d[i],sy2 = sy1 + d[i+1],s2 = sx2 * n + sy2
                guard ok(x: sx2, y: sy2) else {
                    continue
                }
                if bx1 == sx2,by1 == sy2 {
                    let bx2 = bx1 + d[i],by2 = by1 + d[i + 1],b2 = bx2 * n + by2
                    if !ok(x: bx2, y: by2) || dp[s2][b2] <= dp[s1][b1] + 1 {
                        continue
                    }
                    dp[s2][b2] = dp[s1][b1] + 1
                    queue1.append((s2,b2))
                } else {
                    guard dp[s2][b1] > dp[s1][b1] else {
                        continue
                    }
                    dp[s2][b1] = dp[s1][b1]
                    queue.append((s2,b1))
                }
            }
            
        }
        queue = queue1
    }
    
    func ok(x:Int,y:Int) -> Bool {
        guard case 0..<m = x,case 0..<n = y,grid[x][y] != "#" else {
            return false
        }
        return true
    }
    
    return -1
}


//1377. T 秒后青蛙的位置

func frogPosition(_ n: Int, _ edges: [[Int]], _ t: Int, _ target: Int) -> Double {
    var num = Array(repeating: [Int](), count: n+1)
    for edge in edges {
        num[edge[1]] += [edge[0]]
        num[edge[0]] += [edge[1]]
    }
    func dfs(mode:[Bool],t:Int,i:Int) -> Double {
        let nxt = i == 1 ? num[i].count : (num[i].count - 1)
        if t == 0 || nxt == 0 {
            return i == target ? 1.0:0.0
        }
        var tMode = mode
        tMode[i] = true
        var ans = 0.0
        for j in num[i] where !tMode[j] {
            ans += dfs(mode:tMode, t: t-1, i: j)
        }
        return ans/Double(nxt)
    }
    return dfs(mode: Array(repeating: false, count: n+1), t: t, i: 1)
}


//2699. 修改图中的边权
func modifiedGraphEdges(_ n: Int, _ edges: [[Int]], _ source: Int, _ destination: Int, _ target: Int) -> [[Int]] {
    var canChang = Set<String>(),edgeMap = [Int:[(Int,Int)]]()
    for edge in edges {
        if edge[2] == -1 {
            canChang.insert("\(min(edge[0],edge[1]))_\(max(edge[0],edge[1]))")
        }
        edgeMap[edge[0]] = (edgeMap[edge[0]] ?? []) + [(edge[1],max(1,edge[2]))]
        edgeMap[edge[1]] = (edgeMap[edge[1]] ?? []) + [(edge[0],max(1,edge[2]))]
    }
    var i = source,res = [Int:(Int,Int)](),hset = Set<Int>()
    res[i] = (-1,0)
    while hset.count < n {
        hset.insert(i)
        let temp = edgeMap[i]!
        for t in temp where !hset.contains(t.0) {
            if let cur = res[t.0],cur.1 < t.1 + res[i]!.1 {
                
            } else {
                res[t.0] = (i,t.1 + res[i]!.1)
            }
        }
        i = minNum()
    }
    func minNum()-> Int {
        var minNum = (Int.max,-1)
        for (k,v) in res where !hset.contains(k){
            if v.1 < minNum.0 {
                minNum = (v.1,k)
            }
        }
        return minNum.1
    }
    let needAdd = target - res[destination]!.1
    guard needAdd > 0,!canChang.isEmpty else {
        if needAdd == 0 {
            return edges.map { arr in
                return [arr[0],arr[1],max(1,arr[2])]
            }
        }
        return []
    }
    
    var changData = (-1,-1),last = res[destination]!.0,cur = destination
    while cur != source {
        if canChang.contains("\(min(cur,last))_\(max(cur,last))") {
            changData = (min(cur,last),max(cur,last))
            break
        }
        cur = last
        last = res[cur]!.0
    }
    guard changData.0 > 0 else {
        return []
    }
    
    return edges.map { arr in
        if min(arr[0],arr[1]) == changData.0,max(arr[0],arr[1]) == changData.1 {
            return [arr[0],arr[1],needAdd + 1]
        }
        return [arr[0],arr[1],max(1,arr[2])]
    }
}

//1254. 统计封闭岛屿的数目
func closedIsland(_ grid: [[Int]]) -> Int {
    let m = grid.count,n = grid[0].count
    var grid = grid,res = 0
    func find(i:Int,j:Int)->Bool {
        guard case 0..<m = i,case 0..<n = j else {
            //越界了
            return false
        }
        guard grid[i][j] == 0 else {
            //碰到了1,或者之前重复的
            return true
        }
        grid[i][j] = 2
        let left = find(i: i+1, j: j)
        let right = find(i: i-1, j: j)
        let bottom = find(i: i, j: j+1)
        let top = find(i: i, j: j-1)
        return left && right && bottom && top
    }
    
    for i in 0..<m {
        for j in 0..<n where grid[i][j] == 0 {
            if find(i: i, j: j) {
                res += 1
            }
        }
    }
    return res
}

/*
 3
 [
 [2,2,1,1,2,1,2,2,1,2],
 [1,1,2,1,1,2,1,1,1,2],
 [1,2,1,1,1,2,2,1,1,2],
 [2,1,1,2,2,2,2,1,2,1],
 [2,2,2,2,2,2,1,1,1,2],
 [2,1,2,1,2,1,2,1,1,1],
 [1,2,1,2,1,1,2,2,2,1],
 [1,1,1,1,1,1,2,2,2,2],
 [1,1,1,0,0,1,2,1,2,1],
 [1,1,1,0,1,1,2,1,1,2]
 ]
 */

func pondSizes(_ land: [[Int]]) -> [Int] {
    let m = land.count,n = land[0].count
    let locArr = [(1,0),(-1,0),(0,1),(0,-1),(1,1),(-1,-1),(-1,1),(1,-1)]
    var landArr = land
    func findLand(i:Int,j:Int) ->Int {
        guard case 0..<m = i,case 0..<n = j else {
            return 0
        }
        guard landArr[i][j] == 0 else {
            return 0
        }
        var res = 1
        landArr[i][j] = -1
        for loc in locArr {
            res += findLand(i: i + loc.0, j: j + loc.1)
        }
        return res
    }
    
    func findEnd(arr:[Int],tag:Int)->Int {
        var l = 0,r = arr.count
        while l < r {
            let mid = (r + l) >> 1
            if arr[mid] < tag {
                l = mid + 1
            } else {
                r = mid
            }
        }
        return l
    }
    var resArr = [Int]()
    for i in 0..<m {
        for j in 0..<n where landArr[i][j] == 0{
            let temp = findLand(i: i, j: j)
            resArr.insert(temp, at: findEnd(arr: resArr, tag: temp))
        }
    }
    return resArr
}


//834. 树中距离之和
func sumOfDistancesInTree(_ n: Int, _ edges: [[Int]]) -> [Int] {
    guard n > 1 else {
        return [0]
    }
    var nodes = Array(repeating: [Int](), count: n)
    for edge in edges {
        let cur = edge[0],next = edge[1]
        nodes[cur].append(next)
        nodes[next].append(cur)
    }
    var res = Array(repeating: 0, count: n)
    var size = Array(repeating: 0, count: n)
    
    func dfs(x:Int,fa:Int,depth:Int) {
        res[0] += depth
        size[x] = 1
        for y in nodes[x] where y != fa {
            dfs(x: y, fa: x, depth: depth+1)
            size[x] += size[y]
        }
    }
    
    func reRoot(x:Int,fa:Int) {
        for y in nodes[x] where y != fa {
            res[y] = res[x] + n - 2 * size[y]
            reRoot(x: y, fa: x)
        }
    }
    dfs(x: 0, fa: -1, depth: 0)
    reRoot(x: 0, fa: -1)
    return res
}


//874. 模拟行走机器人
// [2,4]
//-2 ：向左转 90 度   -- 1
//-1 ：向右转 90 度   ++ 1
// 0      -1 1  -1 2  -1   3
// [1,1]  [0,1]   [1,-1]  [0,-1]
// [2,4] [2,3] [3,4] [1,3]
// [1,3][2,2][2,3] [2,4] [3,4]
func robotSim(_ commands: [Int], _ obstacles: [[Int]]) -> Int {
    var cur = 0,point = [0,0]
    let arr = [[0,1],[1,0],[0,-1],[-1,0]],mode = 60001
    var set = Set<Int>()
    for obstacle in obstacles {
        set.insert(obstacle[0] * mode + obstacle[1])
    }
    
    func next(i:Int) {
        switch i {
        case -1:
            cur = (cur + 1) % 4
        case -2:
            cur = (cur - 1) < 0 ? 3:(cur - 1)
        default:break
        }
    }
    var res = 0
    for command in commands {
        next(i: command)
        if command > 0 {
            let x = arr[cur][0],y = arr[cur][1]
            for _ in 0..<command {
                if set.contains((point[0] + x) * mode + y + point[1]) {
                    break
                }
                point[0] += x
                point[1] += y
                res = max(point[0] * point[0] + point[1] * point[1],res)
            }
        }
    }
    return res
}

//980. 不同路径 III
//[[1,0,0,0],[0,0,0,0],[0,0,2,-1]]
//1 <= grid.length * grid[0].length <= 20
func uniquePathsIII(_ grid: [[Int]]) -> Int {
    let m = grid.count,n = grid[0].count
    var sumZero = 0,x = 0,y = 0,res = 0
    for i in 0..<m {
        for j in 0..<n  {
            switch grid[i][j] {
                case 0:
                    sumZero += 1
                case 1:
                    x = i
                    y = j
                default:break
            }
        }
    }
    
    func findCorrectWay(i:Int,j:Int,sum:Int,lMode:[Int]) {
            guard case 0..<m = i,case 0..<n = j else {
                return
            }
            switch grid[i][j] {
            case 0 where lMode[i] & (1 << j) == 0:
                var lMode = lMode
                lMode[i] |= 1 << j
                findCorrectWay(i: i+1, j: j, sum: sum + 1, lMode: lMode)
                findCorrectWay(i: i-1, j: j, sum: sum + 1, lMode: lMode)
                findCorrectWay(i: i, j: j+1, sum: sum + 1, lMode: lMode)
                findCorrectWay(i: i, j: j-1, sum: sum + 1, lMode: lMode)
            case 2:
                res += (sum == sumZero ? 1 : 0)
                return
            default:
                return
            }
    }
    let lMode =  Array(repeating: 0, count: m)
    findCorrectWay(i: x+1, j: y, sum: 0, lMode: lMode)
    findCorrectWay(i: x-1, j: y, sum: 0, lMode: lMode)
    findCorrectWay(i: x, j: y+1, sum: 0, lMode: lMode)
    findCorrectWay(i: x, j: y-1, sum: 0, lMode: lMode)
    return res
    
}

//1444. 切披萨的方案数
func ways(_ pizza: [String], _ k: Int) -> Int {
    let mode = 1000000007
    let m = pizza.count,n = pizza[0].count
    var hdp = Array(repeating: Array(repeating: 0, count: n+1), count: m+1)
    var vdp = hdp,numA = 0
    var dp = [String:Int]()
    for i in 1...m {
        for p in pizza[i-1].enumerated() {
            let num = p.element == "A" ? 1:0
            numA += num
            hdp[i][p.offset+1] += hdp[i][p.offset] + num
            vdp[i][p.offset+1] += vdp[i-1][p.offset+1] + num
        }
    }
    func dfs(left:Int,top:Int,num:Int,last:Int) -> Int {
        guard num > 1 else {
            return last > 0 ? 1: 0
        }
        guard left <= n,top <= m else {
            return 0
        }
        let key = "\(left)_\(top)_\(num)"
        if let res = dp[key] {
            return res
        }
        var vSum = 0,res = 0
        for i in left...n {
            //当前删除的列苹果树
            let cur = vdp[m][i] - vdp[top-1][i]
            vSum += cur
            if vSum > 0 {
                if last - vSum < num-1 {
                    break
                }
                res = (res + dfs(left: i+1, top: top, num: num-1, last: last - vSum)) % mode
            }
        }
        vSum = 0
        for j in top...m {
            //当前删除的行苹果树
            let cur = hdp[j][n] - hdp[j][left-1]
            vSum += cur
            if vSum > 0 {
                if last - vSum < num-1 {
                    break
                }
                res = (res + dfs(left: left, top: j+1, num: num-1, last: last - vSum)) % mode
            }
        }
        dp[key] = res % mode
        return dp[key]!
    }
    return dfs(left: 1, top: 1, num: k, last: numA)
}

//1782. 统计点对的数目,二分法
/**
 [[1,2],[2,4],[1,3],[2,3],[2,1]]
 1 3,    2: 2  3:1
 2 4,    1:2  4:1  3:1
 3 2     1:1  2:1
 4 1    2:1
 */
func countPairs(_ n: Int, _ edges: [[Int]], _ queries: [Int]) -> [Int] {
    var degree = Array(repeating: 0, count: n)
    var cnt = [Int:Int]()
    for edge in edges {
        var x = edge[0] - 1,y = edge[1] - 1
        if x > y {
            (x,y) = (y,x)
        }
        degree[x] += 1
        degree[y] += 1
        cnt[x * n + y] = (cnt[x * n + y] ?? 0) + 1
    }
    var res = Array(repeating: 0, count: queries.count)
    let arr = degree.sorted()
    for k in 0..<queries.count {
        let bound = queries[k]
        var total = 0
        for i in 0..<n {
            let j = binarySearch(left: i+1, right: n, targer: bound - arr[i])
            total += n-j
        }
        for (key,value) in cnt {
            let x = key / n,y = key % n
            if degree[x] + degree[y] > bound,degree[x] + degree[y] - value <= bound {
                total -= 1
            }
        }
        res[k] = total
    }
    
    func binarySearch(left:Int,right:Int,targer:Int) -> Int{
        var l = left,r = right
        while l < r {
            let mid = (l + r) >> 1
            if arr[mid] > targer { // 大于target的最小值
                r = mid
            } else {
                l = mid + 1
            }
        }
        return r
    }
    return res
}

//1267. 统计参与通信的服务器
//[[1,0],
 //   [0,1]]
//如果两台服务器位于同一行或者同一列，我们就认为它们之间可以进行通信。
func countServers(_ grid: [[Int]]) -> Int {
    let m = grid.count,n = grid[0].count,mode = 500
    var map = [Int:Int]()
    var res = 0
    for i in 0..<m {
        for j in 0..<n where grid[i][j] == 1 {
            map[i]  = (map[i] ?? 0) + 1
            map[mode + j] = (map[mode + j] ?? 0) + 1
        }
    }
    for i in 0..<m {
        for j in 0..<n where grid[i][j] == 1 {
            if map[i]! > 1 || map[mode + j]! > 1 {
                res += 1
            }
        }
    }
    
    return res
}

//207. 课程表
//[[0,10],[3,18],[5,5],[6,11],[11,14],[13,1],[15,1],[17,4]]
//
func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
    var dp = Array(repeating: [Int](), count: numCourses)
    for prerequisite in prerequisites {
        let a = prerequisite[0],b = prerequisite[1]
        dp[a] += [b]
    }
    
    func finshFind(i:Int,repat: inout [Int]) -> Bool {
        guard !dp[i].isEmpty else {
            return true
        }
        guard repat[i] != 1 else {
            return false
        }
        repat[i] = 1
        for num in dp[i] {
            if (finshFind(i: num, repat: &repat)) {
                repat[num] = 0
            } else {
                return false
            }
        }
        dp[i] = []
        return true
    }
    var arr = Array(repeating: 0, count: numCourses)
    for i in 0..<numCourses where !finshFind(i: i, repat: &arr) {
        return false
    }
    return true
}

//210. 课程表 II
func findOrder(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
    class Node {
        let val:Int
        var preNod:Int = 0
        var nexNod:[Int] = []
        init(val: Int) {
            self.val = val
        }
    }
    mach_absolute_time()
    
    var dp = Array(0..<numCourses).map { Node(val: $0) }
    for prerequisite in prerequisites {
        let a = prerequisite[0],b = prerequisite[1]
        dp[a].preNod += 1
        dp[b].nexNod.append(a)
    }
    var res = [Int](),less = [Int]()
    for i in 0..<numCourses where dp[i].preNod == 0 {
        less.append(i)
    }
    while !less.isEmpty {
        let temp = less.removeFirst()
        res.append(temp)
        let node = dp[temp]
        for next in node.nexNod {
            dp[next].preNod -= 1
            if dp[next].preNod == 0 {
                less.append(next)
            }
        }
    }
    
    
    return res.count == numCourses ? res:[]
}

//1462. 课程表 IV
/**
 你也得到一个数组 queries ，其中 queries[j] = [uj, vj]。对于第 j 个查询，您应该回答课程 uj 是否是课程 vj 的先决条件。

 返回一个布尔数组 answer ，其中 answer[j] 是第 j 个查询的答案。
 [[3,4],[2,3],[1,2],[0,1]], [[0,4],[4,0],[1,3],[3,0]]
0->  1 -> 2 -> 3 -> 4
 */
func checkIfPrerequisite(_ numCourses: Int, _ prerequisites: [[Int]], _ queries: [[Int]]) -> [Bool] {
    
    var dp = Array(repeating: Set<Int>(), count: numCourses)
    
    for prerequisite in prerequisites {
        let a = prerequisite[0],b = prerequisite[1]
        dp[b].insert(a)
    }
    var res = Array(repeating: false, count: queries.count)
    func findPre(_ a:Int,_ hasSet:inout Set<Int>) {
       
        for num in dp[a] where !hasSet.contains(num){
            dp[a] = dp[a].union(dp[num])
            hasSet.insert(num)
            findPre(a, &hasSet)
        }
    }
    
    for i in  0..<numCourses where !dp[i].isEmpty  {
       var hasSet = Set<Int>()
        findPre(i, &hasSet)
    }
    for i in 0..<queries.count  where dp[queries[i][0]].contains(queries[i][1]) {
        res[i] = true
    }
    return res
}

//2596. 检查骑士巡视方案
// 垂直移动两个格子且水平移动一个格子，或水平移动两个格子且垂直移动一个格子
// (2,1) (1,2)
func checkValidGrid(_ grid: [[Int]]) -> Bool {
    let stepArr = [(2,1),(2,-1),(-2,1),(-2,-1),(1,2),(1,-2),(-1,2),(-1,-2)],n = grid.count,sum = n * n - 1
    func find(i:Int,j:Int) ->Bool {
        guard grid[i][j] < sum else {
            return true
        }
        for step in stepArr {
            let l = i + step.0,r = j + step.1
            if case 0..<n = l,
               case 0..<n = r,
               grid[l][r] == (grid[i][j] + 1) {
                return find(i: l, j: r)
            }
        }
        return false
    }
    guard grid[0][0] == 0 else {
        return false
    }
    return find(i: 0, j: 0)
}

//1222. 可以攻击国王的皇后
//她和国王不在同一行/列/对角线
func queensAttacktheKing(_ queens: [[Int]], _ king: [Int]) -> [[Int]] {
    let n = queens.count,sorQueen = queens.sorted { isSmall(arr1: $0, arr2: $1) }
    
    var l = 0,r = queens.count
    while l < r {
        let mid = (l + r) >> 1
        if isSmall(arr1: sorQueen[mid], arr2: king) {
            l = mid + 1
        } else {
            r = mid
        }
    }
    
    var num = 0,res = [[Int]]()
    func isSmall(arr1:[Int],arr2:[Int]) -> Bool {
        guard arr1[0] == arr2[0] else {
            return arr1[0] < arr2[0]
        }
        return arr1[1] < arr2[1]
    }
    func attackNum(i:Int,j:Int) {
        if i == king[0],j > king[1],num & 0b1 == 0 {
            num |= 0b1
            res.append([i,j])
        } else if i == king[0],j < king[1],num & 0b10 == 0 {
            num |= 0b10
            res.append([i,j])
        } else if j == king[1],i < king[0],num & 0b100 == 0 {
            num |= 0b100
            res.append([i,j])
        } else if j == king[1],i > king[0],num & 0b1000 == 0 {
            num |= 0b1000
            res.append([i,j])
        } else if king[0] - i == king[1] - j,king[0] - i > 0,num & 0b10000 == 0 {
            num |= 0b10000
            res.append([i,j])
        } else if king[0] - i == king[1] - j,king[0] - i < 0,num & 0b100000 == 0 {
            num |= 0b100000
            res.append([i,j])
        } else if king[0] - i == -king[1] + j,king[0] - i > 0,num & 0b1000000 == 0 {
            num |= 0b1000000
            res.append([i,j])
        } else if king[0] - i == -king[1] + j,king[0] - i < 0,num & 0b10000000 == 0 {
            num |= 0b10000000
            res.append([i,j])
        }
    }
    
    for i in (0..<l).reversed() {
        attackNum(i: sorQueen[i][0], j: sorQueen[i][1])
    }
    for i in l..<n {
        attackNum(i: sorQueen[i][0], j: sorQueen[i][1])
    }
    
    return res
}

//收集树中金币
//两次拓扑遍历
func collectTheCoins(_ coins: [Int], _ edges: [[Int]]) -> Int {
    let n = coins.count
    var g = Array(repeating: [Int](), count: n)
    var degree = Array(repeating: 0, count: n)
    for edge in edges {
        let x = edge[0],y = edge[1]
        g[x].append(y)
        g[y].append(x)
        degree[x] += 1
        degree[y] += 1
    }
    
    var res = n
    var queue = [Int]()
    for i in 0..<n where degree[i] == 1 && coins[i] == 0 {
        queue.append(i)
    }
    //删除所有的空叶子结点
    while !queue.isEmpty {
        let u = queue.removeLast()
        degree[u] -= 1
        res -= 1
        for v in g[u] {
            degree[v] -= 1
            if degree[v] == 1 && coins[v] == 0 {
                queue.append(v)
            }
        }
    }
    
    // 删除树中所有的叶子节点, 连续删除2次，因为只用到第二个叶子结点处即可
    for _ in 0..<2 {
        for i in 0..<n where degree[i] == 1{
            queue.append(i)
        }
        
        while !queue.isEmpty {
            let u = queue.removeLast()
            degree[u] -= 1
            res -= 1
            for v in g[u] {
                degree[v] -= 1
            }
        }
    }
    return res == 0 ? 0 : (res - 1) * 2
}



//2678. 老人的数目
func countSeniors(_ details: [String]) -> Int {
    var res = 0
    for detail in details {
        let start = detail.index(detail.endIndex, offsetBy: -4),end = detail.index(detail.endIndex, offsetBy: -3)
        if let age = Int(detail[start...end]),age > 60 {
            res += 1
        }
    }
    return res
}

// 1334. 阈值距离内邻居最少的城市
// i 和 j之间最短路径，i和j之间的中间节点小雨等于k
// dfs(k,i,j)=min(dfs(k−1,i,j),dfs(k−1,i,k)+dfs(k−1,k,j))
func findTheCity(_ n: Int, _ edges: [[Int]], _ distanceThreshold: Int) -> Int {
    var swr = Array(repeating: Array(repeating: Int.max / 2, count: n), count: n)
    for edge in edges {
        swr[edge[1]][edge[0]] = edge[2]
        swr[edge[0]][edge[1]] = swr[edge[1]][edge[0]]
    }
    var dp = Array(repeating: Array(repeating: Array(repeating: 0, count: n), count: n), count: n+1)
    dp[0] = swr
    for k in 0..<n {
        for i in 0..<n {
            for j in 0..<n {
                dp[k+1][i][j] = min(dp[k][i][j],dp[k][i][k] + dp[k][k][j])
            }
        }
    }
    var res = 0,minCnt = n
    for i in 0 ..< n {
        var cnt = 0
        for j in 0 ..< n where j != i && dp[n][i][j] <= distanceThreshold {
            cnt += 1
        }
        if cnt <= minCnt {
            minCnt = cnt
            res = i
        }
        
    }
    
    return res
    
}

//2304. 网格中的最小路径代价
//   1 2 3 4 5 6
//
func minPathCost(_ grid: [[Int]], _ moveCost: [[Int]]) -> Int {
    let m = grid.count,n = grid[0].count
    var res = Int.max,dp = grid[0]
    for i in 0..<(m-1) {
        var temp = Array(repeating: Int.max, count: n)
        for j in 0..<n {
            let costs = moveCost[grid[i][j]]
            for z in 0..<n {
                temp[z] = min(costs[z] + dp[j] + grid[i+1][z],temp[z])
                if i == m - 2 {
                    res = min(temp[z],res)
                }
            }
        }
        dp = temp
    }
    return res
}

// 2477. 到达首都的最少油耗
func minimumFuelCost(_ roads: [[Int]], _ seats: Int) -> Int {
    var tree = Array(repeating: [Int](), count: roads.count + 1)
    for road in roads {
        tree[road[0]].append(road[1])
        tree[road[1]].append(road[0])
    }
    func treeBegin(i:Int,llN:Int) -> (Int,Int,Int) {
        guard i == 0 || tree[i].count > 1 else {
            // 有位置
            return (0,1,seats - 1)
        }
        var res = 0,carNum = 0,less = 0
        for num in tree[i] where llN != num  {
            let temp = treeBegin(i: num, llN: i)
            res += temp.0
            carNum += temp.1
            less += temp.2
        }
        res += carNum //到这里花费的
        //去掉多余的车
        carNum = carNum - less / seats
        less = less % seats - 1
        if less == -1 {
            carNum += 1
            less = seats - 1
        }
        return (res,carNum,less)
    }
    return treeBegin(i: 0,llN: -1).0
}

// 2646. 最小化旅行的价格总和
func minimumTotalPrice(_ n: Int, _ edges: [[Int]], _ price: [Int], _ trips: [[Int]]) -> Int {
    var next = Array(repeating: [Int](), count: n)
    for edge in edges {
        next[edge[0]].append(edge[1])
        next[edge[1]].append(edge[0])
    }
    var count = Array(repeating: 0, count: n)
    
    func dfs(node:Int,parent:Int,end:Int) ->Bool {
        guard node != end else {
            count[node] += 1
            return true
        }
        for child in next[node] where child != parent {
            if dfs(node: child, parent: node, end: end) {
                count[node] += 1
                return true
            }
        }
        return false
    }
    for trip in trips {
      let _ = dfs(node: trip[0], parent: -1, end: trip[1])
    }
    
    func dp(node:Int,parent:Int) -> (Int,Int) {
        var res = (price[node] * count[node],price[node] * count[node] / 2)
        for child in next[node] where child != parent {
            let temp = dp(node: child, parent: node)
            res.0 += min(temp.0,temp.1)
            res.1 += temp.0
        }
        return res
    }
    let res = dp(node: 0, parent: -1)
    return min(res.0,res.1)
}


// 1466. 重新规划路线，入读，出度
func minReorder(_ n: Int, _ connections: [[Int]]) -> Int {
    struct Node {
        var input:[Int] = []
        var out: [Int] = []
    }
    var arr:[Node] = Array(repeating: .init(), count: n)
    for connection in connections {
        // 0 -> 1
        arr[connection[1]].input.append(connection[0])
        arr[connection[0]].out.append(connection[1])
    }
    var res = 0,queue = [0],rep = Array(repeating: true, count: n)
    rep[0] = false
    while !queue.isEmpty {
        var temp = [Int]()
        for num in queue  {
            let node = arr[num]
            for num in node.out where rep[num] {
                rep[num] = false
                res += 1
                temp.append(num)
            }
            for num in node.input where rep[num] {
                rep[num] = false
                temp.append(num)
            }
        }
        
        queue = temp
    }
    return res
}
