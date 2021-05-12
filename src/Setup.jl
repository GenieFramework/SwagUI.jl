# using Downloads
# using Tar

# # TODO: make it compatible with Windows, or find a better way to pull pre-built files

# function setup()
#     tmp = "tmp"
#     js = "dist"
#     url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v3.48.0.tar.gz"
#     output = "output.tar.gz"
#     root_dir = dirname(dirname(@__FILE__))

#     if !isdir(joinpath(root_dir, js))
#         println("assets not found, downloading...")
        
#         curr_dir = replace(read(`pwd`, String), "\n" => "")

#         if !isdir(tmp)
#             run(`mkdir $(tmp)`)
#         end
        
#         # download swagger-ui-dist, and move the dist folder to root
#         Downloads.download(url, joinpath(tmp, output))
#         cd(tmp)

#         if Sys.iswindows()
#             folder = "swagger-ui"
#             run(pipeline(`7z x $(output) -so`, `7z x -aoa -si -ttar -o $(folder)`))
#             cd(folder)
#             run(`move $(js) $(root_dir)`)
#             cd("..")
#         else
#             pack_root = replace(read(pipeline(`tar -tf $(output)`, `head -1`, `sed -e 's/\/.*//'`), String), "\n" => "")
#             dist = joinpath(pack_root, js)
#             run(`tar -xf $(output) $(dist)`)
#             run(`mv $(dist) $(root_dir)`)
#         end

#         # clean up
#         cd(curr_dir)
#         run(`rm -rf $(tmp)`)
#     else
#         println("assets found, use existing assets.")
#     end
# end