using Downloads

function setup()
    tmp = "tmp"
    js = "dist"
    url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v3.48.0.tar.gz"
    output = "output.tar.gz"
    root_dir = dirname(dirname(@__FILE__))

    if !isdir(joinpath(root_dir, js))
        println("assets not found, downloading...")
        
        curr_dir = replace(read(`pwd`, String), "\n" => "")

        if !isdir(tmp)
            run(`mkdir $(tmp)`)
        end
        
        # download swagger-ui-dist, and move the dist folder to root
        Downloads.download(url, joinpath(tmp, output))
        cd(tmp)
        pack_root = replace(read(pipeline(`tar -tf $(output)`, `head -1`, `sed -e 's/\/.*//'`), String), "\n" => "")
        dist = joinpath(pack_root, js)
        run(`tar -xf $(output) $(dist)`)
        run(`mv $(dist) $(root_dir)`)
        
        # clean up
        cd(curr_dir)
        run(`rm -rf $(tmp)`)
    else
        println("assets found, use existing assets.")
    end
end