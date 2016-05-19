array = { "a", "b", "c", "d" }

-- Version 1
do
    function permgen(a, n)
        if n == 0 then
            print(a[1], a[2], a[3], a[4])
        else
            for i = 1, n do
                a[n], a[i] = a[i], a[n]
                permgen(a, n - 1)
            end
        end
    end

    print("################# 1 #################")
    permgen(array, 4)
end

-- Version 2
do
    function perco(a, n)
        if n == 0 then
            coroutine.yield(a)
        else
            for i = 1, n do
                a[n], a[i] = a[i], a[n]
                perco(a, n - 1)
            end
        end
    end

    function permco(a)
        local co = coroutine.create(function() perco(a, 4) end)
        return function()
            code, ret = coroutine.resume(co)
            return ret
        end
    end

    print("################# 2 #################")
    for v in permco(array) do
        print(v[1], v[2], v[3], v[4])
    end
end
